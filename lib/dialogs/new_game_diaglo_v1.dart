import 'package:dominos_score/widgets/view_win_and_new_game_v1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void newGameOrResetGame(BuildContext context, String teamWiner) {
  showModalBottomSheet(
    sheetAnimationStyle: AnimationStyle(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOutBack,
    ),

    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return ViewWinAndNewGame(teamWiner: teamWiner);
    },
  );
}
