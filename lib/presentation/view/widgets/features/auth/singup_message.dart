import 'package:flutter/material.dart';

class SingupMessage extends StatelessWidget {
  final String title;
  final String content;
  final String actionText;
  final String actionRoute;
  final Color colorText;
  const SingupMessage({
    super.key,
    required this.title,
    required this.content,
    required this.actionText,
    required this.actionRoute,
    required this.colorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF0F1822) : Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(22),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Color(0xFFFFFFFF) : Color(0xFF121212),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                content,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: isDark
                      ? Color.fromARGB(44, 255, 255, 255)
                      : Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, actionRoute),
                child: Text(
                  actionText,
                  style: TextStyle(
                    color: const Color(0xFFD4A62F),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
