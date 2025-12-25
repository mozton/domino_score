import 'package:dominos_score/presentation/view/widgets/features/game/icon_domino_5-1.dart';
import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuSelectPoint extends StatefulWidget {
  const MenuSelectPoint({super.key});

  @override
  State<MenuSelectPoint> createState() => _MenuSelectPointState();
}

class _MenuSelectPointState extends State<MenuSelectPoint> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<GameViewmodel>(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * (60 / 852),
          width: double.infinity,
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: prov.selectPointsToWin.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              childAspectRatio: 2,
            ),
            itemBuilder: (context, index) {
              final point = prov.selectPointsToWin[index];
              final bool isSelect = prov.pointToWinSelected == point;

              return GestureDetector(
                onTap: () async {
                  prov.pointsToWin = point;
                  prov.selectedPointsToWin(point);
                },
                child: Container(
                  padding: EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                    border: BoxBorder.all(
                      width: 1.5,
                      color: isSelect ? Color(0xFFD4AF37) : Color(0xFFC8C8C8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      prov.selectPointsToWin[index].toString(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3A4A60),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            final prov = context.read<GameViewmodel>();
            prov.changePointToWin();

            Navigator.pop(context);
          },
          child: Container(
            height: size.height * (43 / 852),
            width: size.width * (155 / 393),
            decoration: BoxDecoration(
              color: Color(0xFFD4AF37),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFD4AF37).withValues(alpha: 0.149),
                  offset: Offset(0, 2),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
    );
  }
}
