import 'dart:io';

import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WinAndNewGame extends StatelessWidget {
  final String teamWiner;
  const WinAndNewGame({super.key, required this.teamWiner});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      height: Platform.isAndroid
          ? size.height * (536 / 852)
          : size.height * (436 / 852),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF0F1822) : Color(0xFFE4E9F2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 15),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 4,
              width: size.width * (120 / 393),
              decoration: BoxDecoration(
                color: isDark ? Colors.white : Color(0xFF1E2B43),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          SizedBox(height: 65),
          Image(
            height: size.height * (70 / 852),
            image: AssetImage('assets/icon/fiesta.png'),
          ),
          SizedBox(height: 25),
          Text(
            '¡Partidazo! 🔥',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Color(0xFF1E2B43),
            ),
          ),
          teamWiner.isEmpty
              ? SizedBox.shrink()
              : Text(
                  textAlign: TextAlign.center,
                  teamWiner,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
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
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : Color(0xFF1E2B43).withValues(alpha: 0.5),
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
                contentColor: Color(0xFF1E2B43),
                onTap: () {
                  context.read<GameViewmodel>().startNewGameWithCurrentTeams();
                  Navigator.pop(context);
                },
              ),
              _Buttons(
                buttonColor: Colors.transparent,
                borderColor: isDark ? Colors.white54 : Color(0x1E2B4380),
                assentImage: 'assets/icon/users-group.png',
                titleButton: 'Otro equipo',
                contentColor: isDark ? Colors.white : Color(0xFF1E2B43),
                onTap: () {
                  context.read<GameViewmodel>().startNewGame();
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
  final Color contentColor;

  const _Buttons({
    required this.buttonColor,
    this.borderColor,
    required this.assentImage,
    required this.titleButton,
    required this.onTap,
    required this.contentColor,
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
              color: contentColor,
              image: AssetImage(assentImage),
            ),
            SizedBox(width: 5),
            Text(
              titleButton,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
