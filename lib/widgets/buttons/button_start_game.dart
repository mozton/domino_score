import 'package:dominos_score/dialogs/new_game_diaglo_v1.dart';
import 'package:dominos_score/dialogs/select_point_to_wind_dialog_v1.dart';
import 'package:dominos_score/provider/game_provider.dart';

import 'package:dominos_score/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonStartGame extends StatelessWidget {
  ButtonStartGame({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final prov = context.read<GameProvider>();
    final condition1 = prov.currentGame.teams[0].name == 'Team 1';
    final condition2 = prov.currentGame.teams[1].name == 'Team 2';
    final condition3 = prov.currentGame.pointsToWin <= 0;

    return InkWell(
      onTap: condition1 || condition2
          ? null
          : condition3
          ? () => selectScoreToWin(context)
          : () => newGameOrResetGame(context, ''),

      child: Container(
        height: size.height * 0.0504,
        width: size.width * 0.508,
        decoration: BoxDecoration(
          color: condition1 || condition2
              ? Color(0xFFB28B32).withOpacity(0.5)
              : Color(0xFFB28B32),

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
                condition3 ? ' Empezar Partida' : '  Nueva Partida',

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
