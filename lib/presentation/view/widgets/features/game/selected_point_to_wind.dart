import 'package:dominos_score/presentation/view/widgets/features/game/button/button_menu_select_point.dart';
import 'package:flutter/material.dart';

class SelectPointToWind extends StatelessWidget {
  const SelectPointToWind({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF0F1822) : Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: size.height * (218 / 852),
          width: size.width * 320 / 393,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image(
                      height: 23,
                      width: 23,
                      color: isDark ? Colors.white : Color(0xFF555555),
                      image: AssetImage('assets/icon/square-rounded-x.png'),
                    ),
                  ),
                ],
              ),
              Text(
                'Puntos para esta ronda:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Color(0xFF1E2B43),
                ),
              ),
              SizedBox(height: 15),

              MenuSelectPoint(),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
