import 'package:dominos_score/provider/game_provider.dart';
import 'package:dominos_score/widgets/buttons/body_select_point_to_wind_v1.dart';
import 'package:dominos_score/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void selectPointToWin(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final size = MediaQuery.of(context).size;
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Color(0xFFFFFFFF),
        actions: [
          Container(
            height: size.height * (237 / 852),
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

                MenuSelectPointV1(),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    context.read<GameProvider>().canStartGame;
                    Navigator.pop(context);
                    //TODO: Aqui va la logica para comenzar a colocar los puntos
                  },
                  child: Container(
                    height: size.height * (43 / 852),
                    width: size.width * (155 / 393),
                    decoration: BoxDecoration(
                      color: Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFD4AF37).withOpacity(0.149),
                          offset: Offset(0, 2),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            left: 10,
                            child: IconDomino(colorIcon: Color(0xFF000000)),
                          ),

                          Positioned(
                            top: 8,
                            left: 50,
                            child: Text(
                              'Comenzar',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
