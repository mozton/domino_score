import 'package:dominos_score/models/game/round_model.dart';
import 'package:dominos_score/view/widgets/camera_sheet.dart';
import 'package:dominos_score/view/widgets/add_score_widget_v1.dart';
import 'package:dominos_score/view/widgets/change_name_team_widget_v1.dart';
import 'package:dominos_score/view/widgets/delete_round.dart';
import 'package:dominos_score/view/widgets/selected_point_to_wind.dart';
import 'package:dominos_score/view/widgets/view_win_and_new_game_v1.dart';
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
              final RoundModel newRound;

              if (teamIndex == 0) {
                newRound = RoundModel(
                  team1Points: points,
                  team2Points: 0,
                  number: 0,
                );
              } else {
                newRound = RoundModel(
                  team1Points: 0,
                  team2Points: points,
                  number: 0,
                );
              }
              if (points > 0) {
                await gameProvider.addRound(newRound);
              }
              Navigator.pop(ctx);
            },
            onGetDominoesPointbyImage: () {
              Navigator.pop(ctx);
              UiHelpers.openCameraSheet(context, teamIndex);
            },
          ),
        );
      },
    );
  }

  //Detele Score
  static Future<void> deleteRound(
    BuildContext context,
    int index,
    RoundModel round,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteRound(index: index, round: round);
      },
    );
  }
  // Change Name Team

  static Future<void> changeNameTeam(BuildContext context, int teamId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFFFFF),
          insetPadding: EdgeInsets.zero,

          actions: [
            ChangeNameTeam(
              colorButton: teamId == 1 ? Color(0xFFD4AF37) : Color(0xFF1E2B43),
              teamId: teamId,
            ),
          ],
        );
      },
    );
  }

  static Future<void> selectPointToWin(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectPointToWind();
      },
    );
  }

  // New Game

  static Future<void> newGame(BuildContext context, String teamWiner) async {
    showModalBottomSheet(
      sheetAnimationStyle: AnimationStyle(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutBack,
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return ViewWinAndNewGame(teamWiner: teamWiner);
      },
    );
  }
}
