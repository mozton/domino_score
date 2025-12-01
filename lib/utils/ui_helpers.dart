import 'package:dominos_score/view/screen/camera_sheet.dart';
import 'package:dominos_score/view/widgets/add_score_widget_v1.dart';
import 'package:dominos_score/viewmodel/camera_viewmodel.dart';
import 'package:dominos_score/viewmodel/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UiHelpers {
  static Future<void> showCustomFormDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Custom Form'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Field 1')),
              TextField(decoration: InputDecoration(labelText: 'Field 2')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> openCameraSheet(
    BuildContext context,
    int teamIndex,
  ) async {
    // 1. Usar MultiProvider para proveer el ViewModel de la cámara
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (_) {
            final viewModel = CameraViewModel();
            viewModel.initialize(); // Inicia la cámara al crear el VM
            return viewModel;
          },
          // 2. Usamos el Widget de la Vista
          child: CameraSheet(teamIndex: teamIndex),
        );
      },
    );
    // La limpieza (dispose) se hace automáticamente en el `dispose` del ViewModel.
  }

  // ADD SCORE DIALOG

  static Future<void> showAddScoreDialog(BuildContext context, int teamIndex) {
    final gameProvider = context.read<GameProvider>();

    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFFFFF),
          contentPadding: EdgeInsets.zero,

          content: AddScore(
            colorButton: teamIndex == 0 ? Color(0xFFD4AF37) : Color(0xFF1E2B43),
            onTapPass: () {
              gameProvider.addRound(
                teamIndex == 0 ? 30 : 0,
                teamIndex == 1 ? 30 : 0,
              );
              gameProvider.pointController.clear();
              Navigator.pop(ctx);
            },
            onAddPoints: (pointsText) {
              final points = int.tryParse(pointsText) ?? 0;
              gameProvider.addRound(points, teamIndex);
              gameProvider.pointController.clear();
              Navigator.pop(ctx);
            },
            onGetDominoesPointbyImage: () {
              // 1. Cierra este diálogo primero
              Navigator.pop(ctx);
              // 2. Lanza el flujo modular de la cámara
              UiHelpers.openCameraSheet(context, teamIndex);
            },
            controller: gameProvider.pointController,
          ),
          actions:
              const [], // No necesitamos acciones extra, ya están en AddScore
        );
      },
    );
  }
}
