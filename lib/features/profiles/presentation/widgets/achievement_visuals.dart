import 'package:dominos_score/features/profiles/domain/entities/achievement_entity.dart';
import 'package:flutter/material.dart';

/// Traducción de un icono lógico de medalla a su representación visual.
class AchievementVisual {
  final IconData icon;
  final Color background;
  final Color foreground;

  const AchievementVisual(this.icon, this.background, this.foreground);
}

AchievementVisual visualForAchievement(AchievementIcon icon) {
  switch (icon) {
    case AchievementIcon.trophy:
      return const AchievementVisual(
        Icons.emoji_events_outlined,
        Color(0xFFFFF8E1),
        Color(0xFFF5B000),
      );
    case AchievementIcon.grid:
      return const AchievementVisual(
        Icons.grid_view_rounded,
        Color(0xFFE3F2FD),
        Color(0xFF2196F3),
      );
    case AchievementIcon.skate:
      return const AchievementVisual(
        Icons.roller_skating,
        Color(0xFFE8F5E9),
        Color(0xFF4CAF50),
      );
    case AchievementIcon.bolt:
      return const AchievementVisual(
        Icons.bolt,
        Color(0xFFF5F5F5),
        Color(0xFF9E9E9E),
      );
    case AchievementIcon.remontador:
      return const AchievementVisual(
        Icons.electric_bolt_rounded,
        Color(0xFFF3E5F5),
        Color(0xFFAB47BC),
      );
    case AchievementIcon.star:
      return const AchievementVisual(
        Icons.star_outline_rounded,
        Color(0xFFFFF8E1),
        Color(0xFFF5B000),
      );
    case AchievementIcon.veteran:
      return const AchievementVisual(
        Icons.military_tech_outlined,
        Color(0xFFEDE7F6),
        Color(0xFF7E57C2),
      );
  }
}
