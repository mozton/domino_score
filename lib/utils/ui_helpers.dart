import 'package:dominos_score/view/widgets/camera_sheet.dart';
import 'package:dominos_score/view/widgets/add_score_widget_v1.dart';
import 'package:dominos_score/viewmodel/camera_viewmodel.dart';
import 'package:dominos_score/viewmodel/game_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UiHelpers {
  static Future<void> showCustomFormDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog();
      },
    );
  }

  static Future<void> openCameraSheet(
    BuildContext context,
    int teamIndex,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (_) {
            final viewModel = CameraViewModel();
            viewModel.initialize();
            return viewModel;
          },

          child: CameraSheet(teamIndex: teamIndex),
        );
      },
    );
  }

  // ADD SCORE DIALOG

  static Future<void> showAddScoreDialog(BuildContext context, int teamIndex) {
    final gameProvider = context.read<GameViewModel>();

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
              Navigator.pop(ctx);
              UiHelpers.openCameraSheet(context, teamIndex);
            },
            controller: gameProvider.pointController,
          ),
        );
      },
    );
  }

  // DELETE SCORE
}
