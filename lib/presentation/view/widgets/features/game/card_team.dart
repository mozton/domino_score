import 'package:dominos_score/presentation/view/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CardTeam extends StatelessWidget {
  final String teamName;
  final int points;
  final Color colorCard;
  final Color colorButton;
  final VoidCallback onTap;
  final VoidCallback onTapname;

  const CardTeam({
    super.key,
    required this.teamName,
    required this.points,
    required this.colorCard,
    required this.colorButton,
    required this.onTap,
    required this.onTapname,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapname,
          child: Card(
            elevation: 5,
            color: colorCard,
            shadowColor: const Color(0x1F000000),
            borderOnForeground: false,
            child: Stack(
              children: [
                AnimatedContainer(
                  curve: Curves.linear,
                  duration: Duration(milliseconds: 300),
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.43,
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    left: 24,
                    right: 24,
                  ),
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
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            teamName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Image(
                    height: 20,
                    color: Colors.black26,
                    image: AssetImage('assets/icon/pencil-plus.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 13),
        ButtonAddScore(colorButton: colorButton, onTap: onTap),
      ],
    );
  }
}
