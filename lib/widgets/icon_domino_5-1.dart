import 'package:flutter/material.dart';

import 'dart:math' as Math;

class IconDomino extends StatelessWidget {
  Color colorIcon;
  IconDomino({super.key, required this.colorIcon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: Math.pi / 4,
        child: SizedBox(
          height: 20,
          width: 40,
          child: Stack(
            children: [
              Positioned(
                right: 10.4,
                child: Image(
                  width: 17,
                  height: 17,
                  image: AssetImage('assets/icon/dice-5.png'),
                  color: colorIcon,
                ),
              ),
              Positioned(
                left: 0,
                child: Image(
                  width: 17,
                  height: 17,

                  image: AssetImage('assets/icon/dice-1.png'),
                  color: colorIcon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
