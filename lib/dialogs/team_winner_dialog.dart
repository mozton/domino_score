import 'package:dominos_score/provider/game_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:provider/provider.dart';

void dialogWinsAndroid(BuildContext context, String teamWinner) {
  final prov = Provider.of<GameProvider>(context, listen: false);
  final textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: prov.isDarkMode ? Colors.white : Colors.blueGrey,
  );
  if (prov.team1Total >= prov.pointToWin ||
      prov.team2Total >= prov.pointToWin) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text("$teamWinner is Winner!")),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Text(
                  'Congratulation you won, You wanna play again?',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // GifView.asset(
                //   'assets/competition.gif',
                //   height: 150,
                //   width: 150,
                // ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No', style: textStyle),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<GameProvider>().createNewGame();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  return;
}

void dialogWinIOS(BuildContext context, String teamWinner) {
  final prov = Provider.of<GameProvider>(context, listen: false);

  if (prov.team1Total >= prov.pointToWin ||
      prov.team2Total >= prov.pointToWin) {
    showCupertinoDialog(
      context: context,

      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('$teamWinner is Winner!'),
          content: Column(
            children: [
              Text('Congratulation you won, You wanna play again?'),
              GifView.asset('assets/competition.gif', height: 150, width: 150),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Yes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                context.read<GameProvider>().createNewGame();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
