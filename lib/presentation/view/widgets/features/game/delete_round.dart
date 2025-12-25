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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      backgroundColor: isDark ? Color(0xFF0F1822) : Color(0xFFFFFFFF),

      child: Container(
        padding: EdgeInsets.all(20),
        height: size.height * (257 / 852),
        width: size.width * (350 / 393),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF0F1822) : Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image(
                    height: 23,
                    width: 23,
                    color: isDark ? Colors.white : Color(0xFF555555),
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
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Container(
    height: size.height * (34 / 852),
    width: size.width * (110 / 393),
    decoration: BoxDecoration(
      // color: Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(20),
      border: BoxBorder.all(width: 1.2, color: color),
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Color(0xFF0F1822) : Color(0xFFFFFFFF),
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: onTap,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: size.height * (12 / 852),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: title == 'Cancelar'
                ? color
                : isDark
                ? Colors.white
                : Color(0xFF202020),
          ),
        ),
      ),
    ),
  );
}
