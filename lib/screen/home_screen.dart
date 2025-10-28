import 'package:dominos_score/provider/dialogs.dart';
import 'package:dominos_score/provider/game_provider.dart';
import 'package:dominos_score/widgets/score_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title: const Text(
            'Domino Score',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/setting');
              },
              icon: const Icon(Icons.settings, size: 25, color: Colors.white),
            ),
          ],
        ),
        body: _buildScorePage(context),
      ),
    );
  }

  Widget _buildScorePage(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fondo.jpg'), // Ruta completa
              fit: BoxFit.cover,
              opacity: 0.5, // Hacemos la imagen semi-transparente
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              provider.team1Name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${provider.team1Total}',
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const Text(
                          'VS',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Column(
                          children: [
                            Text(
                              provider.team2Name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${provider.team2Total}',
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: provider.pointController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            final points =
                                int.tryParse(provider.pointController.text) ??
                                0;
                            if (points > 0) {
                              provider.addRound(provider.team1Name, points);
                              provider.pointController.clear();
                              FocusScope.of(context).unfocus();
                              showDialogWins(context, provider.team1Name);
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: Text(provider.team1Name),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onLongPress: () {},
                          onPressed: () async {
                            final points =
                                int.tryParse(provider.pointController.text) ??
                                0;
                            if (points > 0) {
                              provider.addRound(provider.team2Name, points);
                              provider.pointController.clear();
                              FocusScope.of(context).unfocus();

                              await Future.delayed(Duration(milliseconds: 100));
                              showDialogWins(context, provider.team2Name);
                            }
                          },

                          icon: const Icon(Icons.add),
                          label: Text(provider.team2Name),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => _resetGameDialog(context),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('NEW GAME'),
                ),
                SizedBox(height: 15),
                ScoreView(provider: provider),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetGameDialog(BuildContext context) {
    final prov = context.read<GameProvider>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'New Game',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want a New Game?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
            ],
          ),

          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'No',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    prov.resetGame();

                    Navigator.of(context).pop();
                  },
                  child: const Text(
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

  void teamWins(BuildContext context, String teamName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Congratulations! '),
          content: Text('$teamName is Winer,'),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.read<GameProvider>().resetGame();
              },
              child: Text('Yes'),
            ),
            ElevatedButton(onPressed: () {}, child: Text('No')),
          ],
        );
      },
    );
  }
}
