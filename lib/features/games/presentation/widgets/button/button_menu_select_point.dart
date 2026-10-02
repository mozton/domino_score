import 'package:dominos_score/features/games/presentation/bloc/game_bloc.dart';
import 'package:dominos_score/features/games/presentation/widgets/icon_domino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuSelectPoint extends StatefulWidget {
  const MenuSelectPoint({super.key});

  @override
  State<MenuSelectPoint> createState() => _MenuSelectPointState();
}

class _MenuSelectPointState extends State<MenuSelectPoint> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameBloc>().state;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * (80 / 852),
          width: double.infinity,
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.selectPointsToWin.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              childAspectRatio: 2,
            ),
            itemBuilder: (context, index) {
              final point = state.selectPointsToWin[index];
              final bool isSelect = state.pointToWinSelected == point;

              return GestureDetector(
                onTap: () {
                  context.read<GameBloc>().add(PointsToWinSelected(point));
                },
                child: Container(
                  width: 20,
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
                      point.toString(),
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
        GestureDetector(
          onTap: () {
            context.read<GameBloc>().add(PointsToWinChanged());
            Navigator.pop(context);
          },
          child: Container(
            height: size.height * (43 / 852),
            width: MediaQuery.of(context).size.width >= 700
                ? size.width * 0.2
                : size.width * 0.4,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [dialogSave()],
            ),
          ),
        ),
      ],
    );
  }

  Widget dialogSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconDomino(colorIcon: const Color(0xFF000000)),
          const Text(
            'Guardar',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
