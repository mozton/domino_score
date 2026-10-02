import 'package:dominos_score/features/profiles/domain/achievements/achievement_catalog.dart';
import 'package:dominos_score/features/profiles/domain/entities/achievement_entity.dart';
import 'package:dominos_score/features/profiles/domain/entities/player_stats_entity.dart';

/// Evalúa el catálogo de medallas contra las estadísticas de un jugador.
class ComputeAchievementsUseCase {
  const ComputeAchievementsUseCase();

  List<Achievement> call(PlayerStats stats) {
    return AchievementCatalog.definitions
        .map((definition) => definition.evaluate(stats))
        .toList();
  }

  /// Primera medalla obtenida (para usar como "título" en el perfil/miembros).
  Achievement? topObtained(PlayerStats stats) {
    for (final definition in AchievementCatalog.definitions) {
      final achievement = definition.evaluate(stats);
      if (achievement.obtained) return achievement;
    }
    return null;
  }
}
