import 'package:dominos_score/core/di/injection.dart';
import 'package:dominos_score/features/camera/presentation/bloc/camera_bloc.dart';
import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/presentation/bloc/game_bloc.dart';
import 'package:dominos_score/features/games/presentation/pages/detail_game_page.dart';
import 'package:dominos_score/features/games/presentation/widgets/add_score.dart';
import 'package:dominos_score/features/games/presentation/widgets/camera_sheet.dart';
import 'package:dominos_score/features/games/presentation/widgets/change_name_team.dart';
import 'package:dominos_score/features/games/presentation/widgets/delete_round.dart';
import 'package:dominos_score/features/games/presentation/widgets/selected_point_to_wind.dart';
import 'package:dominos_score/features/games/presentation/widgets/team_palette.dart';
import 'package:dominos_score/features/games/presentation/widgets/win_and_new_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UiHelpers {
  static Future<int?> openCameraSheet(
    BuildContext context,
    int teamIndex,
  ) async {
    return await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return BlocProvider(
          create: (_) => getIt<CameraBloc>()..add(const CameraInitialized()),
          child: CameraSheet(teamIndex: teamIndex),
        );
      },
    );
  }

  // ADD SCORE DIALOG

  static Future<void> showAddScoreDialog(BuildContext context, int teamIndex) {
    final gameBloc = context.read<GameBloc>();
    final game = gameBloc.state.currentGame;
    final teamCount = game?.teams.length ?? 2;
    final team = (game != null && teamIndex < game.teams.length)
        ? game.teams[teamIndex]
        : null;

    // Jugadores del equipo (para atribuir la acción, opcional).
    final players = <String>[
      if (team?.player1 != null && team!.player1!.trim().isNotEmpty)
        team.player1!.trim(),
      if (team?.player2 != null && team!.player2!.trim().isNotEmpty)
        team.player2!.trim(),
    ];

    // Puntos de la ronda: solo el equipo elegido anota (el resto 0).
    List<int> pointsFor(int value) =>
        List<int>.generate(teamCount, (i) => i == teamIndex ? value : 0);

    // Las acciones NO modifican los puntos: solo se registran.
    List<RoundEvent> eventsFor(
      List<RoundActionType> actions,
      String? player,
    ) => actions
        .map(
          (action) => RoundEvent(
            type: action,
            teamIndex: teamIndex,
            playerName: player,
          ),
        )
        .toList();

    void submit(int points, List<RoundActionType> actions, String? player) {
      if (points <= 0) return;
      gameBloc.add(
        RoundAdded(
          teamPoints: pointsFor(points),
          events: eventsFor(actions, player),
        ),
      );
    }

    return showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Color(0xFFFFFFFF),
          insetPadding: EdgeInsets.zero,
          child: AddScore(
            colorButton: TeamPalette.button(teamIndex),
            teamName: team?.name ?? 'Equipo ${teamIndex + 1}',
            players: players,
            onTapPass: (actions, player) {
              submit(30, actions, player);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            onAddPoints: (points, actions, player) {
              submit(points, actions, player);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            onCamera: (actions, player) async {
              Navigator.pop(ctx);
              final points = await UiHelpers.openCameraSheet(context, teamIndex);

              if (points != null && points > 0 && context.mounted) {
                submit(points, actions, player);
              }
            },
          ),
        );
      },
    );
  }

  // Delete Score

  static Future<void> deleteRound(
    BuildContext context,
    int index,
    Round round,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteRound(index: index, round: round);
      },
    );
  }

  static Future<void> detailGame(BuildContext context, int index) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: DetailGameScreen(index: index),
        );
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
            colorButton: TeamPalette.button(index),
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
