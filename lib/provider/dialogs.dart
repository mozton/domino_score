import 'package:dominos_score/provider/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showDialogWins(BuildContext context, String teamWinner) {
  final prov = Provider.of<GameProvider>(context, listen: false);
  if (prov.team1Total >= prov.pointToWin ||
      prov.team2Total >= prov.pointToWin) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(" $teamWinner is Winner!"),
          content: Text('Congratulation you won, You wanna play again?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                context.read<GameProvider>().resetGame();
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
  return;
}
