import 'package:dominos_score/provider/providers.dart';
import 'package:dominos_score/widgets/icon_domino_5-1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuSelectPointV1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<GameProvider>(context);
    final size = MediaQuery.of(context).size;

    // final valueListenable = ValueNotifier<String?>(null);
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * (60 / 852),
          width: double.infinity,
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: prov.pointsToWins.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              childAspectRatio: 2,
            ),
            itemBuilder: (context, index) {
              final bool isSelect = prov.pointToWinIsSelected == index;
              final point = prov.pointsToWins[index];

              return GestureDetector(
                onTap: () async {
                  prov.pointsToWin = point;
                  prov.selectPointToWin(index);
                },
                child: Container(
                  padding: EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(22),
                    border: BoxBorder.all(
                      width: 1.3,
                      color: isSelect ? Color(0xFFD4AF37) : Color(0xFFC8C8C8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      prov.pointsToWins[index].toString(),
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
            final prov = context.read<GameProvider>();
            prov.updateScoreToWin();

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
