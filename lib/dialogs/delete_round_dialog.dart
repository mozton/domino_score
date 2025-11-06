import 'package:dominos_score/provider/game_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showDeleteRoundDialog(BuildContext context, int index, int round) {
  showDialog(
    builder: (context) {
      final prov = Provider.of<GameProvider>(context, listen: false);
      final textStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: prov.isDarkMode ? Colors.white : Colors.blueGrey,
      );

      return AlertDialog(
        title: Center(child: Text('Delete Round')),
        content: Text(
          'Are you sure that want to delete round: $round',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No', style: textStyle),
              ),
              TextButton(
                onPressed: () {
                  prov.deletePoint(index);
                  FocusScope.of(context).unfocus();

                  Navigator.pop(context);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
    context: context,
  );
}

void showDeleteRoundIOSDialog(BuildContext context, int index, int round) {
  final prov = Provider.of<GameProvider>(context, listen: false);
  final textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: prov.isDarkMode ? Colors.white : Colors.blueGrey,
  );
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text('Delete Round'),
        content: Text('Are you sure that want to delete round: $round'),
        actions: [
          CupertinoDialogAction(
            child: Text('No', style: textStyle),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              prov.deletePoint(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
