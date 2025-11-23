import 'package:dominos_score/dialogs/new_game_diaglo_v1.dart';
import 'package:dominos_score/provider/game_provider.dart';
import 'package:dominos_score/widgets/add_score_widget_v1.dart';

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
              provider.addRound(30, 0);
              provider.focusNode.unfocus();
              provider.pointController.clear();
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
              Future.delayed(Duration.zero);

              if (provider.totalTeam1Points >=
                  provider.currentGame.pointsToWin) {
                newGameOrResetGame(context, provider.currentGame.teams[0].name);
              }
            },
            onTap: () {
              final points = int.tryParse(provider.pointController.text) ?? 0;
              if (points > 0) {
                provider.addRound(points, 0);
                provider.pointController.clear();
                provider.focusNode.unfocus();
                FocusScope.of(context).unfocus();
                Navigator.pop(context);

                Future.delayed(Duration.zero);

                if (provider.totalTeam1Points >=
                    provider.currentGame.pointsToWin) {
                  newGameOrResetGame(
                    context,
                    provider.currentGame.teams[0].name,
                  );
                }

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
