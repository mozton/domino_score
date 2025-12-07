import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';
import 'package:dominos_score/utils/ui_helpers.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScoreList extends StatelessWidget {
  final String nameTeam1;
  final String nameTeam2;

  const ScoreList({
    super.key,
    required this.nameTeam1,
    required this.nameTeam2,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final poppnins = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: 'Poppins',
      color: Color(0xF01E2B43),
    );

    return GestureDetector(
      onTap: () {
        context.read<GameViewmodel>().selectedRoundByIndex(-1);
      },

      child: Container(
        height: size.height * 0.465,
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF).withOpacity(0.8),
          border: Border.all(width: 1, color: const Color(0xFFDADDE2)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.0550,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Ronda', style: poppnins),
                  Text(nameTeam1, style: poppnins),
                  Text(nameTeam2, style: poppnins),
                ],
              ),
            ),

            Column(children: [SizedBox(height: 319, child: RoundView())]),
          ],
        ),
      ),
    );
  }
}

class RoundView extends StatelessWidget {
  const RoundView({super.key});

  @override
  Widget build(BuildContext context) {
    // escuchar para que el ListView se rebuild cuando cambie selectedIndex

    final size = MediaQuery.of(context).size;
    final poppins = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
      color: Color(0xFF1E2B43),
    );

    return Consumer<GameViewmodel>(
      builder: (BuildContext context, prov, _) {
        final rounds = prov.currentGame.rounds;

        // print(prov.currentGame.rounds);

        if (rounds.isEmpty) {
          return const Center(
            child: Text(
              'No hay rondas registradas',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Colors.black38,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: SizedBox(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: true,
              shrinkWrap: true,
              itemCount: rounds.length,

              itemBuilder: (context, index) {
                final round = rounds[index];
                final isSelected = prov.roundSelected == (index);

                return GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      UiHelpers.deleteRound(context, index, round);
                    } else {
                      prov.selectedRoundByIndex(index);

                      // print(index);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 8,
                      right: 8,
                    ),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: size.height * 0.0410,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(0xFFB00020).withOpacity(
                                0.9,
                              ) // selected (rojo)
                            : Color(0xFFF7F8FA), // not selected (normal)
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(width: 1, color: Color(0xFFDADDE2)),
                      ),

                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: isSelected
                            ? Center(
                                key: ValueKey('trash_$index'),
                                child: Image.asset(
                                  'assets/icon/trash.png',
                                  width: 20,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                key: ValueKey('row_$index'),
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('${round.number}', style: poppins),
                                  Text('${round.team1Points}', style: poppins),
                                  Text('${round.team2Points}', style: poppins),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
