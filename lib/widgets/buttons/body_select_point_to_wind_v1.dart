import 'package:dominos_score/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuSelectPointV1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<GameProvider>(context);

    // final valueListenable = ValueNotifier<String?>(null);
    return SizedBox(
      height: MediaQuery.of(context).size.height * (70 / 852),
      width: double.infinity,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: prov.pointsToWins.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          final bool isSelect = prov.pointToWinIsSelected == index;

          return GestureDetector(
            onTap: () {
              prov.selectPointToWin(index);
            },
            child: Container(
              padding: EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
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
    );
  }
}
