import 'package:dominos_score/dialogs/new_game_diaglo_v1.dart';
import 'package:dominos_score/dialogs/select_point_to_wind_dialog_v1.dart';
import 'package:dominos_score/provider/game_provider.dart';

import 'package:dominos_score/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonStartGame extends StatelessWidget {
  const ButtonStartGame({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final prov = context.read<GameProvider>();

    final isScoreSelect = prov.currentGame.pointsToWin <= 0;

    return InkWell(
      onTap: isScoreSelect
          ? () => selectScoreToWin(context)
          : () {
              if (prov.totalTeam1Points >= prov.currentGame.pointsToWin ||
                  prov.totalTeam2Points >= prov.currentGame.pointsToWin) {
                newGameOrResetGame(context, '');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Termine la partida actual'),
                  ),
                );
              }
            },

      child: Container(
        height: size.height * 0.0504,
        width: size.width * 0.508,
        decoration: BoxDecoration(
          color: Color(0xFFB28B32),

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
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 15,
              child: IconDomino(colorIcon: Color(0xFFFFFFFF)),
            ),
            Positioned(
              left: 55,
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
