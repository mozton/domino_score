import 'package:dominos_score/presentation/viewmodel/camera_viewmodel.dart';
import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class CameraSheet extends StatelessWidget {
  final int teamIndex;

  const CameraSheet({super.key, required this.teamIndex});

  @override
  Widget build(BuildContext context) {
    // Escuchamos el ViewModel para el estado de inicialización
    final viewModel = context.watch<CameraViewModel>();
    final size = MediaQuery.of(context).size;

    if (!viewModel.isInitialized || viewModel.cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final controller = viewModel.cameraController!;

    return SafeArea(
      child: SizedBox(
        height: size.height * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: size.width,
              child: CameraPreview(controller), // Muestra el preview
            ),

            SizedBox(
              width: size.width * 0.8,
              child: ElevatedButton(
                onPressed: () =>
                    _handleTakePicture(context, viewModel), // Lógica delegada
                child: const Text('Contar puntos'),
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
    final controller = viewModel.cameraController!;
    // 1. Tomar foto
    await controller.setFocusMode(FocusMode.auto);
    await Future.delayed(const Duration(milliseconds: 500));
    final image = await controller.takePicture();

    // 2. Mostrar preview y esperar acción
    await _showPreviewDialog(context, image, viewModel);
  }

  Future<void> _showPreviewDialog(
    BuildContext sheetContext,
    XFile image,
    CameraViewModel viewModel,
  ) async {
    final size = MediaQuery.of(sheetContext).size;

    await showDialog(
      context: sheetContext,
      builder: (dialogContext) {
        return AlertDialog(
          // ... UI del diálogo, solo presentación ...
          content: SizedBox(
            width: size.width * 0.7,
            child: Image.file(File(image.path), fit: BoxFit.contain),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Repetir'),
            ),
            TextButton(
              onPressed: () async {
                // 3. Procesar foto (Lógica de negocio en el VM)
                final points = await viewModel.processImage(image);

                // 4. Actualizar estado del juego (Lógica de negocio)
                final provider = sheetContext.read<GameViewmodel>();
                if (teamIndex == 0) {
                  // provider.addRound(points, 0);
                } else {
                  // provider.addRound(0, points);
                }

                // 5. Cerrar todas las vistas
                Navigator.pop(dialogContext); // Cierra el preview
                Navigator.pop(sheetContext); // Cierra el ModalBottomSheet
              },
              child: const Text('Usar foto'),
            ),
          ],
        );
      },
    );
  }
}
