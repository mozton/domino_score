import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryDemoScreen extends StatelessWidget {
  const HistoryDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = context.watch<GameViewmodel>().games;
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Juego No.${games[index].id.toString()}    fecha: ${games[index].createdAt.toString().substring(0, 10)}',
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        'Equipo 1: ${games[index].teams[0].name} (${games[index].teams[0].totalScore}) ',
                        style: TextStyle(
                          color:
                              (games[index].teams[0].totalScore >
                                  games[index].teams[1].totalScore)
                              ? Colors.green
                              : Colors.red,
                          fontWeight:
                              (games[index].teams[0].totalScore >
                                  games[index].teams[1].totalScore)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      Text(
                        'Equipo 2: ${games[index].teams[1].name} (${games[index].teams[1].totalScore})',
                        style: TextStyle(
                          color:
                              (games[index].teams[1].totalScore >
                                  games[index].teams[0].totalScore)
                              ? Colors.green
                              : Colors.red,
                          fontWeight:
                              (games[index].teams[1].totalScore >
                                  games[index].teams[0].totalScore)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
