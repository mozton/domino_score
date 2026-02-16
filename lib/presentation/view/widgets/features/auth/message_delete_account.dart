import 'package:flutter/material.dart';

class MessageDeleteAccount extends StatelessWidget {
  const MessageDeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: 350,
        height: 250,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDark ? Color(0xFF0F1822) : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Eliminar cuenta',
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF202020),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer y perderás todos tus datos.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buttonCancelAndDelete(
                  context,
                  'Cancelar',
                  Colors.grey,
                  () => Navigator.pop(context, false),
                ),
                _buttonCancelAndDelete(
                  context,
                  'Eliminar',
                  Colors.red,
                  () => Navigator.pop(context, true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buttonCancelAndDelete(
  BuildContext context,
  String title,
  Color color,
  VoidCallback onTap,
) {
  final size = MediaQuery.of(context).size;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Container(
    height: size.height * (34 / 852),
    width: size.width * (110 / 393),
    decoration: BoxDecoration(
      // color: Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(20),
      border: BoxBorder.all(width: 1.2, color: color),
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Color(0xFF0F1822) : Color(0xFFFFFFFF),
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: onTap,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: size.height * (12 / 852),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: title == 'Cancelar'
                ? color
                : isDark
                ? Colors.white
                : Color(0xFF202020),
          ),
        ),
      ),
    ),
  );
}
