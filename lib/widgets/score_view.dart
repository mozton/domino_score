import 'dart:io';

import 'package:dominos_score/dialogs/delete_round_dialog.dart';
import 'package:dominos_score/provider/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScoreView extends StatelessWidget {
  final GameProvider provider;
  const ScoreView({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: provider.rounds.length, // Usa provider.rounds
        itemBuilder: (context, index) {
          final round = provider.rounds[index];
          return Container(
            width: MediaQuery.of(context).size.width * 98,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '  ${round.round.toString()} -',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                Text(
                  '${round.pointTeam1}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Text(
                  '${round.pointTeam2}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                IconButton(
                  onPressed: () {
                    if (Platform.isIOS) {
                      showDeleteRoundIOSDialog(
                        context,
                        index,
                        provider.rounds[index].round,
                      );
                    } else {
                      showDeleteRoundDialog(
                        context,
                        index,
                        provider.rounds[index].round,
                      );
                    }
                  },
                  icon: Icon(Icons.delete_outlined, color: Colors.red),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
