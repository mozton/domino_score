import 'package:dominos_score/domain/models/game/round_model.dart';
import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteRound extends StatelessWidget {
  final int index;
  final RoundModel round;

  const DeleteRound({super.key, required this.index, required this.round});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      backgroundColor: Color(0xFFFFFFFF),
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: size.height * (200 / 852),
        width: size.width * 0.95,
        decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // context.read<GameViewmodel>().selectRoundByIndex(null);
                  },
                  child: Image(
                    height: 23,
                    width: 23,
                    color: Color(0xFF555555),
                    image: AssetImage('assets/icon/square-rounded-x.png'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Image(
              height: 30,
              width: 30,
              color: Color(0xFFF2B610),
              image: AssetImage('assets/icon/alertcircle.png'),
            ),
            SizedBox(height: 13),

            // TextDialog
            textDialog(context, index, round.number),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonCancelAndDelete(
                  context,
                  'Cancelar',
                  Color(0xFFB30000),
                  () {
                    Navigator.pop(context);
                  },
                ),
                buttonCancelAndDelete(
                  context,
                  'Eliminar',
                  Color(0xFFC8C8C8),
                  () {
                    context.read<GameViewmodel>().deleteSelectedRound();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

RichText textDialog(BuildContext context, int index, int round) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: [
        TextSpan(
          text: '¿Estás seguro que deseas eliminar el ',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color:
                //  Color(0xFFB30000),
                // Color(0xFFC8C8C8),
                Color(0xFFF2B610),
          ),
        ),
        TextSpan(
          text: 'round $round',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color:
                //  Color(0xFFC8C8C8),
                //  Color(0xFFB30000),
                Color(0xFFF2B610),
          ),
        ),
        TextSpan(
          text: '?',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color:
                // Color(0xFFC8C8C8),
                //  Color(0xFFB30000),
                Color(0xFFF2B610),
          ),
        ),
      ],
    ),
  );
}

Widget buttonCancelAndDelete(
  BuildContext context,
  String title,
  Color color,
  VoidCallback onTap,
) {
  final size = MediaQuery.of(context).size;
  return InkWell(
    onTap: onTap,
    child: Container(
      height: size.height * (34 / 852),
      width: size.width * (104.4 / 393),

      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: BoxBorder.all(width: 1.2, color: color),
      ),

      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: title == 'Cancelar' ? color : Color(0xFF202020),
          ),
        ),
      ),
    ),
  );
}
