import 'package:dominos_score/domain/models/game/round_model.dart';
import 'package:dominos_score/presentation/view/widgets/features/game/camera_sheet.dart';
import 'package:dominos_score/presentation/view/widgets/features/game/add_score.dart';
import 'package:dominos_score/presentation/view/widgets/features/game/change_name_team.dart';
import 'package:dominos_score/presentation/view/widgets/features/game/delete_round.dart';
import 'package:dominos_score/presentation/view/widgets/features/game/selected_point_to_wind.dart';
import 'package:dominos_score/presentation/view/widgets/features/game/win_and_new_game.dart';
import 'package:dominos_score/presentation/viewmodel/camera_viewmodel.dart';
import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';
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

  static Future<int?> openCameraSheet(
    BuildContext context,
    int teamIndex,
  ) async {
    return await showModalBottomSheet<int>(
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
        return Dialog(
          backgroundColor: Color(0xFFFFFFFF),
          insetPadding: EdgeInsets.zero,

          child: AddScore(
            colorButton: teamIndex == 0 ? Color(0xFFD4AF37) : Color(0xFF1E2B43),
            onTapPass: () async {
              final points = int.tryParse("30") ?? 0;
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
            onGetDominoesPointbyImage: () async {
              Navigator.pop(ctx);
              final points = await UiHelpers.openCameraSheet(
                context,
                teamIndex,
              );

              // Si recibimos puntos válidos, guardamos la ronda
              if (points != null && points > 0 && context.mounted) {
                final newRound = teamIndex == 0
                    ? RoundModel(team1Points: points, team2Points: 0, number: 0)
                    : RoundModel(
                        team1Points: 0,
                        team2Points: points,
                        number: 0,
                      );

                await gameProvider.addRound(newRound);
              }
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

  static Future<void> changeNameTeam(
    BuildContext context,
    int teamId,
    int index,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,

          child: ChangeNameTeam(
            colorButton: index == 0 ? Color(0xFFD4AF37) : Color(0xFF1E2B43),
            teamId: teamId,
          ),
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
        return WinAndNewGame(teamWiner: teamWiner);
      },
    );
  }
}
