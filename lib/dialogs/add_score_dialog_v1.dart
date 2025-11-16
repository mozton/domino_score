import 'package:dominos_score/dialogs/new_game_diaglo_v1.dart';
import 'package:dominos_score/provider/game_provider.dart';
import 'package:dominos_score/widgets/add_score_widget_v1.dart';
import 'package:dominos_score/widgets/view_win_and_new_game_v1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            onTapPass: () {
              provider.addRound(provider.team1Name, 30);
              provider.focusNode.unfocus();
              provider.pointController.clear();
              Navigator.pop(context);

              if (provider.team1Total >= provider.pointsToWin) {
                Future.delayed(Duration.zero);

                newGameOrResetGame(context, provider.team1Name);
              }
            },
            onTap: () {
              final points = int.tryParse(provider.pointController.text) ?? 0;
              if (points > 0) {
                provider.addRound(provider.team1Name, points);
                provider.pointController.clear();
                provider.focusNode.unfocus();
                FocusScope.of(context).unfocus();
                Navigator.pop(context);

                if (provider.team1Total >= provider.pointsToWin) {
                  Future.delayed(Duration.zero);

                  newGameOrResetGame(context, provider.team1Name);
                }
                //TODO: aqui el dialogo de ganador
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
            onTapPass: () {
              provider.addRound(provider.team2Name, 30);
              provider.pointController.clear();
              provider.focusNode.unfocus();
              Navigator.pop(context);
              if (provider.team2Total >= provider.pointsToWin) {
                Future.delayed(Duration.zero);

                newGameOrResetGame(context, provider.team2Name);
              }
            },
            onTap: () {
              print('Team2');
              final points = int.tryParse(provider.pointController.text) ?? 0;
              if (points > 0) {
                provider.addRound(provider.team2Name, points);
                provider.pointController.clear();
                provider.focusNode.unfocus();
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
                if (provider.team2Total >= provider.pointsToWin) {
                  Future.delayed(Duration.zero);

                  newGameOrResetGame(context, provider.team2Name);
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
