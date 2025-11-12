import 'package:dominos_score/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ButtonStartGame extends StatelessWidget {
  const ButtonStartGame({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
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
            Positioned(left: 20, top: 15, child: IconDomino()),
            Positioned(
              left: 55,
              top: 13,
              child: Text(
                'Empezar Partida',
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
