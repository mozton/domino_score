import 'package:dominos_score/features/games/presentation/bloc/game_bloc.dart';
import 'package:dominos_score/features/games/presentation/widgets/icon_domino.dart';
import 'package:dominos_score/features/games/presentation/widgets/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonStartGame extends StatelessWidget {
  const ButtonStartGame({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = context.read<GameBloc>();
    final game = bloc.state.currentGame;

    final isScoreSelect = game == null || game.pointsToWin <= 0;

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
                if (game.teams.any((t) => t.totalScore >= game.pointsToWin)) {
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
        child: Center(child: _dialogNewGame(isScoreSelect, context)),
      ),
    );
  }

  Widget _dialogNewGame(bool isScoreSelect, BuildContext context) {
    return SizedBox(
      height: 50,
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconDomino(colorIcon: Color(0xFFFFFFFF)),
          Text(
            isScoreSelect ? ' Empezar Partida' : '  Nueva Partida',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
