import 'package:dominos_score/provider/game_provider.dart';
import 'package:dominos_score/widgets/add_score_widget_v1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void addScoreTeam1(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final provider = Provider.of<GameProvider>(context);
      return AlertDialog(
        backgroundColor: Color(0xFFFFFFFF),
        insetPadding: EdgeInsets.zero,
        actions: [
          AddScore(
            onTap: () {
              print('hola');
              final points = int.tryParse(provider.pointController.text) ?? 0;
              if (points > 0) {
                provider.addRound(provider.team1Name, points);
                provider.pointController.clear();
                provider.focusNode.unfocus();
                FocusScope.of(context).unfocus();
                //TODO: aqui el dialogo de ganador

                Navigator.pop(context);
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
    context: context,
    builder: (context) {
      final provider = Provider.of<GameProvider>(context);
      return AlertDialog(
        backgroundColor: Color(0xFFFFFFFF),
        insetPadding: EdgeInsets.zero,
        actions: [
          AddScore(
            onTap: () {
              print('Team2');
              final points = int.tryParse(provider.pointController.text) ?? 0;
              if (points > 0) {
                provider.addRound(provider.team2Name, points);
                provider.pointController.clear();
                provider.focusNode.unfocus();
                FocusScope.of(context).unfocus();
                //TODO: aqui el dialogo de ganador

                Navigator.pop(context);
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
