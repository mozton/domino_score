import 'package:dominos_score/viewmodel/game_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonAddTeamAndScoreV1 extends StatelessWidget {
  final Color colorButton;
  final VoidCallback onTap;

  const ButtonAddTeamAndScoreV1({
    super.key,
    required this.colorButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final prov = context.read<GameViewModel>();
    final isScoreSelect = prov.currentGame.pointsToWin <= 0;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: colorButton.withOpacity(0.1),
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
                      color: colorButton.withOpacity(0.5),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Image(
                    height: 20,
                    width: 20,
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
