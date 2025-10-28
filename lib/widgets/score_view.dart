import 'package:dominos_score/provider/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ScoreView extends StatelessWidget {
  final GameProvider provider;
  const ScoreView({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: provider.rounds.length, // Usa provider.rounds
        itemBuilder: (context, index) {
          final round = provider.rounds[index];
          return Slidable(
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  label: 'Delete round: ${provider.rounds[index].round}',
                  // icon: Icons.delete_outline_rounded,
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
            child: Container(
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
                      showDeleteRoundDialog(context, index);
                    },
                    icon: Icon(Icons.delete_outlined, color: Colors.red[200]),
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

void showDeleteRoundDialog(BuildContext context, int index) {
  showDialog(
    builder: (context) {
      final prov = Provider.of<GameProvider>(context, listen: false);

      return AlertDialog(
        title: Text('Delete Round'),
        content: Text('Are you sure that want to delete round'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              prov.deletePoint(index);
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
    context: context,
  );
}
