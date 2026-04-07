import 'package:dominos_score/presentation/view/widgets/features/game/button/button_menu_select_point.dart';
import 'package:flutter/material.dart';

class SelectPointToWind extends StatelessWidget {
  const SelectPointToWind({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    var orientation = MediaQuery.of(context).orientation;
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
          height: MediaQuery.of(context).size.height >= 700
              ? orientation == Orientation.landscape
                    ? MediaQuery.of(context).size.height * (330 / 852)
                    : MediaQuery.of(context).size.height * (225 / 852)
              : MediaQuery.of(context).size.height * (218 / 852),
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

              SizedBox(
                height: size.height >= 700 ? size.height * (15 / 852) : 5,
              ),
              MenuSelectPoint(),

              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
