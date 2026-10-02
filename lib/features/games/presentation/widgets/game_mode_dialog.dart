import 'package:dominos_score/features/games/domain/entities/game_mode.dart';
import 'package:flutter/material.dart';

/// Selector del modo/equipos a jugar.
Future<GameMode?> showGameModeDialog(BuildContext context, GameMode current) {
  return showDialog<GameMode>(
    context: context,
    builder: (context) => _GameModeDialog(current: current),
  );
}

class _GameModeDialog extends StatelessWidget {
  final GameMode current;

  const _GameModeDialog({required this.current});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF0F1822) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Equipos a jugar',
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
                'Elegir el modo inicia una partida nueva (se reinicia el marcador).',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...GameMode.values.map(
              (mode) => _ModeTile(
                mode: mode,
                selected: mode == current,
                isDark: isDark,
                onTap: () => Navigator.pop(context, mode),
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

class _ModeTile extends StatelessWidget {
  final GameMode mode;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _ModeTile({
    required this.mode,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      leading: Icon(
        mode.isTeams ? Icons.groups_rounded : Icons.person_rounded,
        color: selected ? const Color(0xFFD4AF37) : Colors.grey,
      ),
      title: Text(
        mode.label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF1E2B43),
        ),
      ),
      subtitle: Text(
        '${mode.teamCount} equipos · ${mode.playersPerTeam} jugador${mode.playersPerTeam == 1 ? '' : 'es'} por equipo',
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          color: isDark ? Colors.white54 : Colors.black45,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle, color: Color(0xFFD4AF37))
          : null,
    );
  }
}
