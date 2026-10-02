import 'package:equatable/equatable.dart';
import 'package:dominos_score/features/profiles/domain/entities/player_stats_entity.dart';

/// Icono lógico de una medalla. La UI lo mapea a un [IconData] y colores.
enum AchievementIcon { trophy, grid, skate, bolt, remontador, star, veteran }

/// Medalla / título de un jugador, ya evaluada contra sus estadísticas.
class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final AchievementIcon icon;
  final bool obtained;

  /// Texto de progreso cuando aún no se obtuvo (ej. "4 de 5 victorias").
  final String? progressText;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.obtained = false,
    this.progressText,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    icon,
    obtained,
    progressText,
  ];
}

/// Definición de una medalla: regla, meta y datos de presentación.
class AchievementDefinition {
  final String id;
  final String title;
  final String description;
  final AchievementIcon icon;

  /// Meta numérica (para el texto de progreso).
  final int goal;

  /// Unidad mostrada en el progreso (ej. "victorias", "partidas").
  final String unit;

  /// Valor actual del jugador para esta medalla.
  final int Function(PlayerStats stats) current;

  const AchievementDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.goal,
    required this.unit,
    required this.current,
  });

  Achievement evaluate(PlayerStats stats) {
    final value = current(stats);
    final obtained = value >= goal;
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      obtained: obtained,
      progressText: obtained ? null : '$value de $goal $unit',
    );
  }
}
