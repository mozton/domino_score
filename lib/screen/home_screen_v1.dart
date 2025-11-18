import 'package:dominos_score/dialogs/add_score_dialog_v1.dart';
import 'package:dominos_score/dialogs/change_name_team_dialog_v1.dart';
import 'package:dominos_score/provider/providers.dart';
import 'package:dominos_score/widgets/buttons/button_start_game.dart';
import 'package:dominos_score/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenV1 extends StatelessWidget {
  const HomeScreenV1({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, prov, child) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xFFE4E9F2), const Color(0xFFFAFAFA)],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,

            appBar: _appBarHome(context),
            body: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cards Teams & Buttons Change Name & Add Score
                      CardTeam(
                        teamName: prov.team1Name,
                        points: prov.team1Total,
                        colorCard: const Color(0xFFF7E7AF),
                        colorButton: Color(0xFFD4AF37),
                        onTap: prov.canStartGame
                            ? () {
                                addScoreTeam1(context);
                              }
                            : () {
                                addNameTeam1Dialog(context);
                              },
                      ),
                      CardTeam(
                        teamName: prov.team2Name,
                        points: prov.team2Total,
                        colorCard: const Color(0xFFFFFFFF),
                        colorButton: const Color(0xFF1E2B43),
                        onTap: prov.canStartGame
                            ? () {
                                addScoreTeam2(context);
                              }
                            : () {
                                addNameTeam2Dialog(context);
                              },
                      ),
                    ],
                  ),

                  SizedBox(height: 27),

                  // Score List View
                  ScoreList(
                    nameTeam1: prov.team1Name,
                    nameTeam2: prov.team2Name,
                  ),

                  SizedBox(height: 17),

                  // Button Start Game & New Game
                  ButtonStartGame(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // AppBarHome

  AppBar _appBarHome(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: MediaQuery.of(context).size.height * 0.099,
      backgroundColor: const Color(0xFFE4E9F2),
      title: Text(
        'Dominos App',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed('/setting'),
            child: Image(
              height: 28,
              width: 28,
              image: AssetImage('assets/icon/settings.png'),
            ),
          ),
        ),
      ],
    );
  }
}
