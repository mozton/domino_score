import 'package:flutter/material.dart';

class CardTeam extends StatelessWidget {
  String teamName;
  int points;
  Color colorCard;
  Color colorButton;
  VoidCallback onTap;
  CardTeam({
    super.key,
    required this.teamName,
    required this.points,
    required this.colorCard,
    required this.colorButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          color: colorCard,
          shadowColor: const Color(0x1F000000),
          borderOnForeground: false,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width * 0.43,
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 24),
            decoration: BoxDecoration(
              color: colorCard,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x26000000),
                  offset: const Offset(4, 4),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  points.toString(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  teamName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 13),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: colorButton.withOpacity(0.1),
          onTap: onTap,
          child: Card(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.0316,
              width: MediaQuery.of(context).size.width * 0.278,

              decoration: BoxDecoration(
                color: colorButton,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorButton.withOpacity(0.5),
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(child: Icon(Icons.add)),
            ),
          ),
        ),
      ],
    );
  }
}
