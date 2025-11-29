import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dominos_score/dialogs/new_game_diaglo_v1.dart';
import 'package:dominos_score/provider/game_provider.dart';
import 'package:dominos_score/services/dominos_counter.dart';
import 'package:dominos_score/widgets/add_score_widget_v1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> _openCamera(BuildContext context, int teamIndex) async {
  final cameras = await availableCameras();
  if (cameras.isEmpty) return;

  final controller = CameraController(
    cameras.first,
    ResolutionPreset.max,
    enableAudio: false,
    imageFormatGroup: ImageFormatGroup.jpeg,
  );

  await controller.initialize();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (bottomSheetContext) {
      final size = MediaQuery.of(bottomSheetContext).size;
      final dominosCounter = DominosCounter();

      return SafeArea(
        child: SizedBox(
          height: size.height * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: size.width,
                // height: size.width / controller.value.aspectRatio,
                child: CameraPreview(controller),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.setFocusMode(FocusMode.auto);
                    await Future.delayed(const Duration(milliseconds: 500));
                    final image = await controller.takePicture();

                    await showDialog(
                      context: bottomSheetContext,
                      builder: (dialogContext) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: size.width * 0.7,
                                child: Image.file(
                                  File(image.path),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  dialogContext,
                                ); // close preview only
                              },
                              child: const Text('Repetir'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final bytes = await File(
                                  image.path,
                                ).readAsBytes();
                                final base64Image = base64Encode(bytes);

                                final points = await dominosCounter
                                    .getDominosPointFromImg(base64Image);
                                final provider = Provider.of<GameProvider>(
                                  context,
                                  listen: false,
                                );

                                if (teamIndex == 0) {
                                  provider.addRound(points, 0);
                                } else {
                                  provider.addRound(0, points);
                                }

                                Navigator.pop(dialogContext);
                                Navigator.pop(bottomSheetContext);
                                Navigator.pop(context);
                              },
                              child: const Text('Usar foto'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Contar puntos'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await controller.dispose();
  });
}

void addScoreTeam1(BuildContext context) {
  showDialog(
    animationStyle: AnimationStyle(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOutCubicEmphasized,
    ),
    context: context,
    builder: (context) {
      final provider = Provider.of<GameProvider>(context);
      return AlertDialog(
        backgroundColor: Color(0xFFFFFFFF),
        insetPadding: EdgeInsets.zero,
        actions: [
          AddScore(
            onGetDominoesPointbyImage: () {
              _openCamera(context, 0);
            },
            onTapPass: () {
              provider.addRound(30, 0);
              provider.focusNode.unfocus();
              provider.pointController.clear();
              provider.focusNode.unfocus();
              Navigator.pop(context);
              Future.delayed(Duration.zero);

              if (provider.totalTeam1Points >=
                  provider.currentGame.pointsToWin) {
                newGameOrResetGame(context, provider.currentGame.teams[0].name);
              }
              print(
                'total1: ${provider.totalTeam1Points} totalwin: ${provider.currentGame.pointsToWin} ',
              );
            },
            onTap: () {
              final points = int.tryParse(provider.pointController.text) ?? 0;
              if (points > 0) {
                provider.addRound(points, 0);
                provider.pointController.clear();
                provider.focusNode.unfocus();
                Navigator.pop(context);
                Future.delayed(Duration.zero);

                if (provider.totalTeam1Points >=
                    provider.currentGame.pointsToWin) {
                  newGameOrResetGame(
                    context,
                    provider.currentGame.teams[0].name,
                  );
                }
                print(
                  'total1: ${provider.totalTeam1Points} totalwin: ${provider.currentGame.pointsToWin} ',
                );

                return;
              }
            },
            colorButton: Color(0xFFD4AF37),
            controller: provider.pointController,
          ),
        ],
      );
    },
  );
}

void addScoreTeam2(BuildContext context) {
  showDialog(
    animationStyle: AnimationStyle(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOutCubicEmphasized,
    ),
    context: context,
    builder: (context) {
      final provider = Provider.of<GameProvider>(context);
      return AlertDialog(
        backgroundColor: Color(0xFFFFFFFF),
        insetPadding: EdgeInsets.zero,
        actions: [
          AddScore(
            onGetDominoesPointbyImage: () {
              _openCamera(context, 1);
            },
            onTapPass: () {
              provider.addRound(0, 30);
              provider.pointController.clear();
              provider.focusNode.unfocus();
              Navigator.pop(context);
              Future.delayed(Duration.zero);

              if (provider.totalTeam2Points >=
                  provider.currentGame.pointsToWin) {
                newGameOrResetGame(context, provider.currentGame.teams[1].name);
              }
            },
            onTap: () {
              final points = int.tryParse(provider.pointController.text) ?? 0;
              if (points > 0) {
                provider.addRound(0, points);
                provider.pointController.clear();
                provider.focusNode.unfocus();
                FocusScope.of(context).unfocus();
                Navigator.pop(context);

                Future.delayed(Duration.zero);
                if (provider.totalTeam2Points >=
                    provider.currentGame.pointsToWin) {
                  newGameOrResetGame(
                    context,
                    provider.currentGame.teams[1].name,
                  );
                }
              }
            },
            colorButton: Color(0xFF1E2B43),
            controller: provider.pointController,
          ),
        ],
      );
    },
  );
}
