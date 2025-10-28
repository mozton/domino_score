import 'package:dominos_score/provider/game_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key}); // Elimina el parámetro gameModel

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Pizarra de Dominó')),
          body: Column(
            children: [
              _buildTeamScore(provider),
              _buildRoundsHistory(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTeamScore(GameProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Total'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${provider.team1Total}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${provider.team2Total}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundsHistory(GameProvider provider) {
    return Expanded(
      child: ListView.builder(
        itemCount: provider.rounds.length, // Usa provider.rounds
        itemBuilder: (context, index) {
          final round = provider.rounds[index];
          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: Colors.white12,
                ),
              ],
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 9,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 15),
                  Text(
                    'Round ${round.round.toString()}',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(width: 15),
                  Text(
                    '${round.pointTeam1}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    '${round.pointTeam2}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      // _deleteRoundDialog(context);
                      // provider.deletePoint(index);
                    },
                    icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// void _deleteRoundDialog(BuildContext context) {
//   showDialog(context: context, builder: builder);
// }
