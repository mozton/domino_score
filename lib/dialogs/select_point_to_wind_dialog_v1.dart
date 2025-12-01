import 'package:dominos_score/view/widgets/buttons/button_menu_select_point.dart';
import 'package:flutter/material.dart';

void selectScoreToWin(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final size = MediaQuery.of(context).size;
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Color(0xFFFFFFFF),
        actions: [
          Container(
            height: size.height * (218 / 852),
            width: size.width * 320 / 393,
            decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
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
                        color: Color(0xFF555555),
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
                    color: Color(0xFF1E2B43),
                  ),
                ),
                SizedBox(height: 15),

                MenuSelectPoint(),

                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      );
    },
  );
}
