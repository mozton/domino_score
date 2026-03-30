import 'package:flutter/material.dart';

class ButtonDeleteAccount extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;
  final String title;
  const ButtonDeleteAccount({
    super.key,
    required this.onPressed,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: size.height * (44 / 852),
      width: size.width * (200 / 393),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0x00000000), const Color(0x00000000)]
              : [const Color(0xFFE4E9F2), const Color(0xFFFAFAFA)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1.0, color: color),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: size.height * (14 / 852),
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
