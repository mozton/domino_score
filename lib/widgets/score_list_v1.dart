import 'package:dominos_score/dialogs/delete_round_dialog_v1.dart';
import 'package:dominos_score/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScoreList extends StatelessWidget {
  String nameTeam1;
  String nameTeam2;

  ScoreList({super.key, required this.nameTeam1, required this.nameTeam2});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<GameProvider>(context);
    final size = MediaQuery.of(context).size;
    final poppnins = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: 'Poppins',
      color: Color(0xF01E2B43),
    );

    return GestureDetector(
      onTap: () {
        prov.selectRoundByIndex(null);
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
    final prov = Provider.of<GameProvider>(context);

    // final reversedRound = prov.rounds.reversed.toList();

    final size = MediaQuery.of(context).size;

    final poppins = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
      color: Color(0xFF1E2B43),
    );
    final rounds = prov.rounds;

    if (rounds.isEmpty) {
      return const Center(child: Text('No hay rondas registradas'));
    }

    return SingleChildScrollView(
      child: SizedBox(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          reverse: true,
          shrinkWrap: true,
          itemCount: prov.rounds.length,
          itemBuilder: (context, index) {
            final round = prov.rounds[index];
            final isSelected = prov.roundSelected == (index);

            return GestureDetector(
              onTap: () {
                if (isSelected) {
                  deleteRoundDialogV1(context, index, round.round);
                } else {
                  prov.selectRoundByIndex(index);
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
                        ? Color(0xFFB00020).withOpacity(0.9) // selected (rojo)
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('${round.round}', style: poppins),
                              Text('${round.pointTeam1}', style: poppins),
                              Text('${round.pointTeam2}', style: poppins),
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
  }
}
