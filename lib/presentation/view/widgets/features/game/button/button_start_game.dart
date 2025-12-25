import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';
import 'package:dominos_score/ui_helpers.dart';

import 'package:dominos_score/presentation/view/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonStartGame extends StatelessWidget {
  const ButtonStartGame({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final prov = context.read<GameViewmodel>();

    final isScoreSelect = prov.currentGame.pointsToWin <= 0;

    return Container(
      height: size.height * 0.0504,
      width: size.width * 0.508,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Color(0x00000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          backgroundColor: Color(0xFFB28B32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        onPressed: isScoreSelect
            ? () => UiHelpers.selectPointToWin(context)
            : () {
                if (prov.totalTeam1Points >= prov.currentGame.pointsToWin ||
                    prov.totalTeam2Points >= prov.currentGame.pointsToWin) {
                  UiHelpers.newGame(context, '');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Termine la partida actual'),
                    ),
                  );
                }
              },

        child: Stack(
          children: [
            Positioned(
              left: 8,
              top: 15,
              child: IconDomino(colorIcon: Color(0xFFFFFFFF)),
            ),
            Positioned(
              left: 40,
              top: 13,
              child: Text(
                isScoreSelect ? ' Empezar Partida' : '  Nueva Partida',

                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
