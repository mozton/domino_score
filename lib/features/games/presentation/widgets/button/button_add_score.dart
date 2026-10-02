import 'package:dominos_score/features/games/presentation/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonAddScore extends StatelessWidget {
  final Color colorButton;
  final VoidCallback onTap;

  const ButtonAddScore({
    super.key,
    required this.colorButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<GameBloc>().state;
    final isScoreSelect =
        state.currentGame == null || state.currentGame!.pointsToWin <= 0;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: colorButton.withValues(alpha: 0.1),
      onTap: isScoreSelect ? null : onTap,
      child: Card(
        child: isScoreSelect
            ? SizedBox.shrink()
            : Container(
                height: MediaQuery.of(context).size.height * 0.0316,
                width: MediaQuery.of(context).size.width * 0.278,
                decoration: BoxDecoration(
                  color: colorButton,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorButton.withValues(alpha: 0.5),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Image(
                    height: MediaQuery.of(context).size.height * (20 / 852),
                    width: MediaQuery.of(context).size.height * (20 / 852),
                    image: AssetImage('assets/icon/plus.png'),
                    color: colorButton != Color(0xFFD4AF37)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
      ),
    );
  }
}
