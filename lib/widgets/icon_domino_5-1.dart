import 'dart:math' as Math;

import 'package:flutter/material.dart';

class IconDomino extends StatelessWidget {
  const IconDomino({super.key});

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
                right: 10,
                child: Image(
                  width: 17,
                  height: 17,
                  image: AssetImage('assets/icon/dice-5.png'),
                ),
              ),
              Positioned(
                left: 0,
                child: Image(
                  width: 17,
                  height: 17,

                  image: AssetImage('assets/icon/dice-1.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
