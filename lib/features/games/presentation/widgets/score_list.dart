import 'package:dominos_score/features/games/presentation/bloc/game_bloc.dart';
import 'package:dominos_score/features/games/presentation/widgets/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScoreList extends StatelessWidget {
  final List<String> teamNames;

  const ScoreList({super.key, required this.teamNames});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final poppnins = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: 'Poppins',
      color: Color(0xF01E2B43),
    );

    return GestureDetector(
      onTap: () {
        context.read<GameBloc>().add(const RoundSelected(-1));
      },
      child: Container(
        height: size.height * 0.465,
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF).withValues(alpha: 0.8),
          border: Border.all(width: 1, color: const Color(0xFFDADDE2)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.055,
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text(
                      'Ronda',
                      textAlign: TextAlign.center,
                      style: poppnins,
                    ),
                  ),
                  ...teamNames.map(
                    (name) => Expanded(
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: poppnins,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: RoundView(teamNames: teamNames),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RoundView extends StatelessWidget {
  final List<String> teamNames;

  const RoundView({super.key, required this.teamNames});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final poppins = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
      color: isDark ? Colors.white : Colors.black38,
    );

    return BlocBuilder<GameBloc, GameState>(
      builder: (BuildContext context, GameState state) {
        final rounds = state.currentGame?.rounds ?? const [];

        if (rounds.isEmpty) {
          return const Center(
            child: Text(
              'No hay rondas registradas',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Colors.black38,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: SizedBox(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: true,
              shrinkWrap: true,
              itemCount: rounds.length,
              itemBuilder: (context, index) {
                final round = rounds[index];
                final isSelected = state.roundSelected == (index);

                final isDark = Theme.of(context).brightness == Brightness.dark;

                return GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      UiHelpers.deleteRound(context, index, round);
                    } else {
                      context.read<GameBloc>().add(RoundSelected(index));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 8,
                      right: 8,
                    ),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: size.height * 0.0410,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(0xFFB00020).withValues(alpha: 0.9)
                            : isDark
                            ? Color(0xFF0F1822)
                            : Color(0xFFDADDE2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          width: 1,
                          color: isSelected
                              ? Color(0xFFB00020).withValues(alpha: 0.9)
                              : isDark
                              ? Color(0xFF0F1822)
                              : Color(0xFFF7F8FA),
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: isSelected
                            ? Center(
                                key: ValueKey('trash_$index'),
                                child: Image.asset(
                                  'assets/icon/trash.png',
                                  width: 20,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                key: ValueKey('row_$index'),
                                children: [
                                  SizedBox(
                                    width: 48,
                                    child: Text(
                                      '${round.number}',
                                      textAlign: TextAlign.center,
                                      style: poppins,
                                    ),
                                  ),
                                  ...List.generate(teamNames.length, (i) {
                                    return Expanded(
                                      child: Text(
                                        '${round.pointsFor(i)}',
                                        textAlign: TextAlign.center,
                                        style: poppins,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
