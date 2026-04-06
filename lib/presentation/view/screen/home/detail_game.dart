import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailGameScreen extends StatelessWidget {
  final int index;
  const DetailGameScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameViewmodel>().games[index];
    final team1Name = game.teams[0].name;
    final team2Name = game.teams[1].name;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final poppins = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: 'Poppins',
      color: isDark ? Colors.white : const Color(0xFF1E2B43),
    );

    return Center(
      child: Container(
        height: size.height * 0.6,
        width: size.width * (360 / 393),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? const Color(0xFF0F1822) : const Color(0xFFFFFFFF),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24), // Spacer for centering title
                Text(
                  'Detalle de Juego',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: isDark ? Colors.white : const Color(0xFF1E2B43),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image(
                    height: 24,
                    color: isDark ? Colors.white : const Color(0XFF1C1400),
                    image: const AssetImage('assets/icon/square-rounded-x.png'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: Center(child: Text('Ronda', style: poppins))),
                Expanded(child: Center(child: Text(team1Name, style: poppins))),
                Expanded(child: Center(child: Text(team2Name, style: poppins))),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildScoreList(index)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

Widget _buildScoreList(int index) {
  return Consumer<GameViewmodel>(
    builder: (context, prov, child) {
      final rounds = prov.games[index].rounds;
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        reverse: true,
        itemCount: rounds.length,
        itemBuilder: (context, roundIndex) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          
          final poppins = TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: isDark ? Colors.white : const Color(0xFF1E2B43),
          );
          
          final round = rounds[roundIndex];
          final isSelected = prov.roundSelected == roundIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: MediaQuery.of(context).size.height * 0.045,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFB00020).withValues(alpha: 0.9)
                    : isDark
                        ? const Color(0xFF1A2430)
                        : const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1,
                  color: isSelected
                      ? const Color(0xFFB00020).withValues(alpha: 0.9)
                      : isDark
                          ? const Color(0xFF2A323C)
                          : const Color(0xFFE4E9F2),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: isSelected
                    ? Center(
                        key: ValueKey('trash_$roundIndex'),
                        child: Image.asset(
                          'assets/icon/trash.png',
                          width: 20,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        key: ValueKey('row_$roundIndex'),
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(child: Center(child: Text('${round.number}', style: poppins))),
                          Expanded(child: Center(child: Text('${round.team1Points}', style: poppins))),
                          Expanded(child: Center(child: Text('${round.team2Points}', style: poppins))),
                        ],
                      ),
              ),
            ),
          );
        },
      );
    },
  );
}
