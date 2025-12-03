import 'package:dominos_score/models/game/round_model.dart';
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
    final gameProvider = context.read<GameViewmodel>();

    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFFFFF),
          contentPadding: EdgeInsets.zero,

          content: AddScore(
            colorButton: teamIndex == 0 ? Color(0xFFD4AF37) : Color(0xFF1E2B43),
            onTapPass: () {
              Navigator.pop(ctx);
            },
            onAddPoints: (pointsText) async {
              final points = int.tryParse(pointsText) ?? 0;

              // 1. Crear el objeto RoundModel según qué equipo anota
              final RoundModel newRound;

              if (teamIndex == 0) {
                // El equipo 1 anota
                newRound = RoundModel(
                  // El 'number' debe ser la ronda que *sigue*, pero el
                  // método addRound se encarga de calcular nextRoundNumber.
                  // Aquí solo necesitamos los puntos.
                  team1Points: points,
                  team2Points: 0,
                  // El ViewModel ignorará estos valores por defecto, pero los requiere el constructor
                  number: 0,
                );
              } else {
                // El equipo 2 anota
                newRound = RoundModel(
                  team1Points: 0,
                  team2Points: points,
                  number: 0,
                );
              }

              // 2. LLAMAR AL MÉTODO DEL VIEWMODEL PARA GUARDAR LA RONDA
              if (points > 0) {
                await gameProvider.addRound(newRound); // ⬅️ AGREGAR ESTO
              }

              // 3. Cerrar el diálogo
              Navigator.pop(ctx);
            },
            onGetDominoesPointbyImage: () {
              Navigator.pop(ctx);
              UiHelpers.openCameraSheet(context, teamIndex);
            },
            // controller: gameProvider.pointController,
          ),
        );
      },
    );
  }

  // DELETE SCORE
}
