import 'package:dominos_score/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonAddTeamAndScoreV1 extends StatelessWidget {
  Color colorButton;
  VoidCallback onTap;

  ButtonAddTeamAndScoreV1({
    super.key,
    required this.colorButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: colorButton.withOpacity(0.1),
      onTap: onTap,
      child: Card(
        child: Container(
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
              image: context.read<GameProvider>().canStartGame
                  ? AssetImage('assets/icon/plus.png')
                  : AssetImage('assets/icon/pencil-plus.png'),
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
