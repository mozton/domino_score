import 'package:dominos_score/services/local/database_helper.dart';
import 'package:dominos_score/utils/ui_helpers.dart';
import 'package:dominos_score/view/widgets/buttons/button_start_game.dart';

import 'package:dominos_score/view/widgets/view_win_and_new_game_v1.dart';
import 'package:dominos_score/view/widgets/widgets.dart';
import 'package:dominos_score/viewmodel/game_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewmodel>(
      builder: (context, prov, child) {
        final teams = prov.currentGame.teams;
        final winnerTeam = prov.winnerTeam;

        if (winnerTeam != null) {
          // Usamos addPostFrameCallback para asegurar que se llama después del build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ModalRoute.of(context)?.isCurrent == true) {
              Future.delayed(Duration.zero);
              _showWinnerModal(context, winnerTeam.name);
              prov.resetWinnerState();
            }
          });
        }

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
                              points: teams[0].totalScore,

                              colorCard: const Color(0xFFF7E7AF),
                              colorButton: Color(0xFFD4AF37),
                              onTap: () =>
                                  UiHelpers.showAddScoreDialog(context, 0),
                              onTapname: () => UiHelpers.changeNameTeam(
                                context,
                                teams[0].id!,
                              ),
                            ),
                            CardTeam(
                              teamName: teams[1].name,
                              points: teams[1].totalScore,
                              colorCard: const Color(0xFFFFFFFF),
                              colorButton: const Color(0xFF1E2B43),
                              onTap: () =>
                                  UiHelpers.showAddScoreDialog(context, 1),
                              onTapname: () => UiHelpers.changeNameTeam(
                                context,
                                teams[1].id!,
                              ),
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
            : Container(
                color: Colors.white,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      DatabaseHelper dbHelper = DatabaseHelper();
                      await dbHelper.deleteDB();
                    },
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
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
            onTap: () {
              Navigator.pushNamed(context, '/setting');
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

  // Tu función de modal
  static void _showWinnerModal(BuildContext context, String teamWiner) {
    showModalBottomSheet(
      sheetAnimationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutBack,
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        // Asegúrate de importar ViewWinAndNewGame
        // import 'package:dominos_score/view/widgets/view_win_and_new_game.dart';
        return ViewWinAndNewGame(teamWiner: teamWiner);
      },
    );
  }
}
