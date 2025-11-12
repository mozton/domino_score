import 'package:dominos_score/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScoreList extends StatelessWidget {
  String nameTeam1;
  String nameTeam2;

  ScoreList({super.key, required this.nameTeam1, required this.nameTeam2});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final poppnins = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: 'Poppins',
      color: Color(0xF01E2B43),
    );

    return Container(
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

          SingleChildScrollView(
            child: Column(children: [RoundView(size: size)]),
          ),
        ],
      ),
    );
  }
}

class RoundView extends StatelessWidget {
  const RoundView({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<GameProvider>(context, listen: false);
    final poppins = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
      color: Color(0xFF1E2B43),
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.builder(
        itemCount: prov.rounds.length,
        itemBuilder: (context, index) {
          final round = prov.rounds[index];
          return prov.showButtonDelete
              ? GestureDetector(
                  onTap: () => prov.isSelectedToDelete(false),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 8,
                      right: 8,
                    ),
                    child: Container(
                      height: size.height * 0.0410,
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(width: 1, color: Color(0xFFDADDE2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('${round.round}', style: poppins),
                          Text('${round.pointTeam1}', style: poppins),
                          Text('${round.pointTeam2}', style: poppins),
                        ],
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => prov.isSelectedToDelete(true),
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
                        color: Color(0xFFB00020).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(width: 1, color: Color(0xFFDADDE2)),
                      ),
                      child: Center(
                        child: Image(
                          image: AssetImage('assets/icon/trash.png'),
                          width: 20,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
