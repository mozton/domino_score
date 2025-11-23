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
    final team1IsNoEmty = prov.currentGame.teams[0].name == 'Team 1';
    final team2IsNoEmty = prov.currentGame.teams[1].name == 'Team 2';
    final isScoreSelect = prov.currentGame.pointsToWin <= 0;

    return InkWell(
      onTap: team1IsNoEmty || team2IsNoEmty
          ? null
          : isScoreSelect
          ? () => selectScoreToWin(context)
          : () => newGameOrResetGame(context, ''),

      child: Container(
        height: size.height * 0.0504,
        width: size.width * 0.508,
        decoration: BoxDecoration(
          color: team1IsNoEmty || team2IsNoEmty
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
