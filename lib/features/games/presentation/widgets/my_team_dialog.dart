import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:flutter/material.dart';

class MyTeamSelection {
  final int? teamIndex;

  const MyTeamSelection(this.teamIndex);
}

/// Selector de "mi equipo" (para calcular victorias/derrotas del perfil).
Future<MyTeamSelection?> showMyTeamDialog(BuildContext context, Game game) {
  return showDialog<MyTeamSelection>(
    context: context,
    builder: (context) => _MyTeamDialog(game: game),
  );
}

class _MyTeamDialog extends StatelessWidget {
  final Game game;

  const _MyTeamDialog({required this.game});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF0F1822) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        '¿En qué equipo juegas?',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF1E2B43),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Sirve para contar tus victorias/derrotas. Solo afecta a tu perfil.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(game.teams.length, (index) {
              final team = game.teams[index];
              final selected = game.myTeamIndex == index;
              return ListTile(
                onTap: () =>
                    Navigator.pop(context, MyTeamSelection(index)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                leading: Icon(
                  Icons.groups_rounded,
                  color: selected ? const Color(0xFFD4AF37) : Colors.grey,
                ),
                title: Text(
                  team.name,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF1E2B43),
                  ),
                ),
                trailing: selected
                    ? const Icon(
                        Icons.check_circle,
                        color: Color(0xFFD4AF37),
                      )
                    : null,
              );
            }),
            ListTile(
              onTap: () =>
                  Navigator.pop(context, const MyTeamSelection(null)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              leading: Icon(
                Icons.remove_circle_outline,
                color: game.myTeamIndex == null
                    ? const Color(0xFFD4AF37)
                    : Colors.grey,
              ),
              title: Text(
                'Ninguno',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
