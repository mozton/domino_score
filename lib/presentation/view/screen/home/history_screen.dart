import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryDemoScreen extends StatelessWidget {
  const HistoryDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: corregir overflow
    final games = context.watch<GameViewmodel>().games;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0x00000000), const Color(0x00000000)]
              : [const Color(0xFFE4E9F2), const Color(0xFFFAFAFA)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: size.height * 0.099,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Historial',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            final team1 = game.teams[0];
            final team2 = game.teams[1];
            final date = game.createdAt.toString().substring(0, 10);

            // Determine winner for coloring
            final team1Won = team1.totalScore > team2.totalScore;
            final team2Won = team2.totalScore > team1.totalScore;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F1822) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Juego #${game.id}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E2B43),
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTeamRow(team1.name, team1.totalScore, team1Won, isDark),
                  const SizedBox(height: 8),
                  _buildTeamRow(team2.name, team2.totalScore, team2Won, isDark),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTeamRow(String name, int score, bool isWinner, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: isWinner ? FontWeight.w600 : FontWeight.w400,
              color: isDark
                  ? (isWinner ? const Color(0xFFD4AF37) : Colors.white70)
                  : (isWinner
                        ? const Color(0xFF1E2B43)
                        : const Color(0xFF6B7280)),
            ),
          ),
        ),
        Text(
          '$score',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isWinner
                ? const Color(0xFFD4AF37) // Gold for winner
                : (isDark ? Colors.white70 : const Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }
}
