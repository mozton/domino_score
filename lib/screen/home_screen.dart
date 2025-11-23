import 'package:dominos_score/dialogs/add_score_dialog_v1.dart';
import 'package:dominos_score/dialogs/change_name_team_dialog_v1.dart';
import 'package:dominos_score/provider/providers.dart';
import 'package:dominos_score/services/database_helper.dart';
import 'package:dominos_score/widgets/buttons/button_start_game.dart';
import 'package:dominos_score/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, prov, child) {
        final teams = prov.currentGame.teams;
        final isScoreSelect = prov.currentGame.pointsToWin <= 0;

        //TODO: corregir parpadeo
        return prov.currentGame.teams.isNotEmpty
            ? Container(
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
                              teamName: teams[0].name,
                              points: prov.totalTeam1Points,
                              colorCard: const Color(0xFFF7E7AF),
                              colorButton: Color(0xFFD4AF37),
                              onTap: isScoreSelect
                                  ? () => addNameTeam1Dialog(context)
                                  : () => addScoreTeam1(context),
                            ),
                            CardTeam(
                              teamName: teams[1].name,
                              points: prov.totalTeam2Points,
                              colorCard: const Color(0xFFFFFFFF),
                              colorButton: const Color(0xFF1E2B43),
                              onTap: isScoreSelect
                                  ? () => addNameTeam2Dialog(context)
                                  : () => addScoreTeam2(context),
                            ),
                          ],
                        ),

                        SizedBox(height: 27),

                        // Score List View
                        ScoreList(
                          nameTeam1: teams[0].name,
                          nameTeam2: teams[1].name,
                        ),

                        SizedBox(height: 17),

                        // Button Start Game & New Game
                        ButtonStartGame(),
                      ],
                    ),
                  ),
                ),
              )
            : Container();
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
            onTap: () {
              DatabaseHelper db = DatabaseHelper();
              db.deleteDB();
            },
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
