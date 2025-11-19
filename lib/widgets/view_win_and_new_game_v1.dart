import 'dart:io';

import 'package:dominos_score/provider/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ViewWinAndNewGame extends StatelessWidget {
  String teamWiner;
  ViewWinAndNewGame({super.key, required this.teamWiner});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: Platform.isAndroid
          ? size.height * (536 / 852)
          : size.height * (436 / 852),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFE4E9F2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 15),
          Container(
            height: 4,
            width: size.width * (120 / 393),
            decoration: BoxDecoration(
              color: Color(0xFF1E2B43),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          SizedBox(height: 65),
          Image(
            height: 70,
            color: Color(0xFF1E2B43),
            image: AssetImage('assets/icon/confetti.png'),
          ),
          SizedBox(height: 25),
          Text(
            '¡Partidazo! 🔥',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2B43),
            ),
          ),
          Text(
            ' "$teamWiner" ',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xFFC6A15B),
            ),
          ),
          Text(
            '¿Listos para la revancha?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E2B43).withOpacity(0.5),
            ),
          ),
          SizedBox(height: 55),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Buttons(
                buttonColor: Color(0xFFC6A15B),
                assentImage: 'assets/icon/flame.png',
                titleButton: 'Mismo equipo',
                onTap: () {
                  // context.read<GameProvider>().createNewGame();
                  Navigator.pop(context);
                },
              ),
              _Buttons(
                buttonColor: Colors.transparent,
                borderColor: Color(0x1E2B4380),
                assentImage: 'assets/icon/users-group.png',
                titleButton: 'Otro equipo',
                onTap: () {
                  // context.read<GameProvider>().createGameNewTeam();
                  context.read<GameProvider>().pointsToWin = 0;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final Color buttonColor;
  final Color? borderColor;
  final String assentImage;
  final String titleButton;
  final VoidCallback onTap;

  const _Buttons({
    super.key,
    required this.buttonColor,
    this.borderColor,
    required this.assentImage,
    required this.titleButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height * (43 / 852),
        width: size.width * (155 / 393),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(22),
          border: BoxBorder.all(
            width: 1.5,
            color: borderColor ?? Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1E2B4326),
              offset: Offset(4, 8),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: 20,
              color: Color(0xFF1E2B43),
              image: AssetImage(assentImage),
            ),
            SizedBox(width: 5),
            Text(
              titleButton,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E2B43),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
