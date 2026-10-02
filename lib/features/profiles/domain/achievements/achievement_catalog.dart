import 'package:dominos_score/features/profiles/domain/entities/achievement_entity.dart';
import 'package:dominos_score/features/profiles/domain/entities/player_stats_entity.dart';

/// Catálogo de medallas disponibles y sus reglas.
///
/// Las medallas basadas en `capicuas`, `zapateros`, `wins`... se desbloquearán
/// cuando la jugabilidad registre esas acciones. Las basadas en `gamesPlayed`
/// ya se pueden obtener hoy.
class AchievementCatalog {
  static const List<AchievementDefinition> definitions = [
    AchievementDefinition(
      id: 'rey_capicua',
      title: 'Rey de la Capicúa',
      description: 'Ha cerrado más de 10 partidas con capicúa.',
      icon: AchievementIcon.trophy,
      goal: 10,
      unit: 'capicúas',
      current: _capicuas,
    ),
    AchievementDefinition(
      id: 'tranca_mesas',
      title: 'El Tranca-Mesas',
      description: 'Ha ganado 15 partidas en el corillo.',
      icon: AchievementIcon.grid,
      goal: 15,
      unit: 'victorias',
      current: _wins,
    ),
    AchievementDefinition(
      id: 'zapatero',
      title: 'El Zapatero',
      description: 'Dejó a un equipo rival en 0 puntos en una partida.',
      icon: AchievementIcon.skate,
      goal: 1,
      unit: 'zapateros',
      current: _zapateros,
    ),
    AchievementDefinition(
      id: 'racha',
      title: 'Racha Imparable',
      description: 'Ganar 5 partidas consecutivas en el corillo.',
      icon: AchievementIcon.bolt,
      goal: 5,
      unit: 'victorias',
      current: _wins,
    ),
    AchievementDefinition(
      id: 'remontador',
      title: 'Remontador Épico',
      description: 'Ganó partidas tras ir perdiendo por 50+ puntos.',
      icon: AchievementIcon.remontador,
      goal: 20,
      unit: 'victorias',
      current: _wins,
    ),
    AchievementDefinition(
      id: 'primera_partida',
      title: 'Primera Partida',
      description: 'Registra tu primera partida en el corillo.',
      icon: AchievementIcon.star,
      goal: 1,
      unit: 'partidas',
      current: _gamesPlayed,
    ),
    AchievementDefinition(
      id: 'jugador_constante',
      title: 'Jugador Constante',
      description: 'Registra 10 partidas.',
      icon: AchievementIcon.veteran,
      goal: 10,
      unit: 'partidas',
      current: _gamesPlayed,
    ),
    AchievementDefinition(
      id: 'veterano',
      title: 'Veterano del Corillo',
      description: 'Registra 50 partidas.',
      icon: AchievementIcon.veteran,
      goal: 50,
      unit: 'partidas',
      current: _gamesPlayed,
    ),
  ];

  static int _capicuas(PlayerStats s) => s.capicuas;
  static int _zapateros(PlayerStats s) => s.zapateros;
  static int _wins(PlayerStats s) => s.wins;
  static int _gamesPlayed(PlayerStats s) => s.gamesPlayed;
}
