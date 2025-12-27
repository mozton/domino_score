import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'dart:math' as Math;

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double deltaX;
  final Curve curve;
  final ShakeController controller;

  const ShakeWidget({
    super.key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
  });

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: widget.curve),
    );

    widget.controller._setState(this);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
      }
    });
  }

  void shake() {
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final sineValue = Math.sin(4 * Math.pi * animation.value); // 2 cycles
        return Transform.translate(
          offset: Offset(sineValue * widget.deltaX, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class ShakeController {
  ShakeWidgetState? _state;

  void shake() {
    _state?.shake();
  }

  void _setState(ShakeWidgetState state) {
    _state = state;
  }
}
