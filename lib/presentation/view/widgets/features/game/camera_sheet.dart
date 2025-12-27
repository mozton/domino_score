import 'package:dominos_score/presentation/viewmodel/camera_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class CameraSheet extends StatefulWidget {
  final int teamIndex;

  const CameraSheet({super.key, required this.teamIndex});

  @override
  State<CameraSheet> createState() => _CameraSheetState();
}

class _CameraSheetState extends State<CameraSheet> {
  bool _isTakingPicture = false;

  @override
  Widget build(BuildContext context) {
    // Escuchamos el ViewModel para el estado de inicialización
    final viewModel = context.watch<CameraViewModel>();
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!viewModel.isInitialized || viewModel.cameraController == null) {
      return Center(
        child: CircularProgressIndicator(
          color: isDark ? const Color(0xFFD4AF37) : const Color(0xFF1E2B43),
        ),
      );
    }

    final controller = viewModel.cameraController!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar (Close Button)
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // 2. Camera Preview (4:3 Aspect Ratio)
            Container(
              width: size.width,
              height: size.width * 4 / 3, // 3:4 Aspect Ratio (Portrait)
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: OverflowBox(
                  alignment: Alignment.center,
                  maxHeight: double.infinity,
                  maxWidth: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: size.width,
                      // We rely on the aspect ratio of the camera to determine height
                      // This ensures it fills width and overflows height (or vice versa)
                      child: CameraPreview(controller),
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // 3. Controls
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () => _handleTakePicture(context, viewModel),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          // color: Colors.white.withOpacity(0.2),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: _isTakingPicture
                              ? SizedBox.shrink()
                              : Image(
                                  image: AssetImage('assets/icon/camera.png'),
                                  color: Colors.white,
                                  height:
                                      MediaQuery.of(context).size.height *
                                      (24 / 853),
                                  width:
                                      MediaQuery.of(context).size.width *
                                      (24 / 393),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tomar foto',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleTakePicture(
    BuildContext context,
    CameraViewModel viewModel,
  ) async {
    if (_isTakingPicture) return;

    setState(() {
      _isTakingPicture = true;
    });

    try {
      final controller = viewModel.cameraController!;
      // 1. Tomar foto
      await controller.setFocusMode(FocusMode.auto);
      await Future.delayed(const Duration(milliseconds: 500));
      final image = await controller.takePicture();

      if (!context.mounted) return;

      // 2. Mostrar preview y esperar acción
      await _showPreviewDialog(context, image, viewModel);
    } catch (e) {
      // print("Error taking picture: $e");
    } finally {
      if (context.mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  Future<void> _showPreviewDialog(
    BuildContext sheetContext,
    XFile image,
    CameraViewModel viewModel,
  ) async {
    final result = await showDialog<int>(
      context: sheetContext,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) =>
          _PreviewDialog(image: image, viewModel: viewModel),
    );

    if (result != null && sheetContext.mounted) {
      Navigator.pop(sheetContext, result);
    }
  }
}

class _PreviewDialog extends StatefulWidget {
  final XFile image;
  final CameraViewModel viewModel;

  const _PreviewDialog({required this.image, required this.viewModel});

  @override
  State<_PreviewDialog> createState() => _PreviewDialogState();
}

class _PreviewDialogState extends State<_PreviewDialog> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF0F1822)
        : const Color(0xFFFFFFFF);
    final textColor = isDark ? Colors.white : Colors.black;

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen
            Container(
              width: size.width * 0.7,
              height: (size.width * 0.7) * 4 / 3, // 4:3 Aspect Ratio
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(widget.image.path), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),

            // Texto de confirmación o Loader
            if (_isProcessing) ...[
              const CircularProgressIndicator(color: Color(0xFFD4AF37)),
              const SizedBox(height: 10),
              Text(
                'Procesando...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
            ] else ...[
              Text(
                '¿Usar esta foto?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6B7280),
                    ),
                    child: const Text(
                      'Repetir',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isProcessing = true;
                      });

                      try {
                        final points = await widget.viewModel.processImage(
                          widget.image,
                        );

                        if (context.mounted) {
                          Navigator.pop(context, points);
                        }
                      } catch (e) {
                        // Manejo de error simple, podría ser un Toast
                        // print("Error procesando imagen: $e");
                        if (mounted) {
                          setState(() {
                            _isProcessing = false;
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Usar foto',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
