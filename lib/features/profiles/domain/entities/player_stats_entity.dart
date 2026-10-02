import 'package:equatable/equatable.dart';

/// Estadísticas de un jugador.
///
/// Ahora mismo se calculan a partir de las partidas locales, pero las acciones
/// finas (victorias/derrotas por jugador, capicúas, zapateros) se poblarán
/// cuando la jugabilidad registre quién hizo cada jugada. Hasta entonces quedan
/// en 0 pero el modelo ya las soporta.
class PlayerStats extends Equatable {
  final int gamesPlayed;
  final int gamesFinished;
  final int totalRounds;
  final int totalPoints;
  final double averagePointsPerGame;
  final int bestGamePoints;

  /// Victorias / derrotas del jugador (pendiente de la metodología de juego).
  final int wins;
  final int losses;

  /// Capicúas y zapateros realizados (pendiente de la metodología de juego).
  final int capicuas;
  final int zapateros;

  const PlayerStats({
    this.gamesPlayed = 0,
    this.gamesFinished = 0,
    this.totalRounds = 0,
    this.totalPoints = 0,
    this.averagePointsPerGame = 0,
    this.bestGamePoints = 0,
    this.wins = 0,
    this.losses = 0,
    this.capicuas = 0,
    this.zapateros = 0,
  });

  static const empty = PlayerStats();

  int get playedDecided => wins + losses;

  /// Porcentaje de victorias (0-100).
  double get winRate =>
      playedDecided > 0 ? (wins / playedDecided) * 100 : 0.0;

  /// Nivel derivado de la actividad y las victorias.
  int get level {
    final computed = 1 + (gamesPlayed ~/ 5) + (wins ~/ 10);
    return computed > 99 ? 99 : computed;
  }

  PlayerStats copyWith({
    int? gamesPlayed,
    int? gamesFinished,
    int? totalRounds,
    int? totalPoints,
    double? averagePointsPerGame,
    int? bestGamePoints,
    int? wins,
    int? losses,
    int? capicuas,
    int? zapateros,
  }) {
    return PlayerStats(
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      gamesFinished: gamesFinished ?? this.gamesFinished,
      totalRounds: totalRounds ?? this.totalRounds,
      totalPoints: totalPoints ?? this.totalPoints,
      averagePointsPerGame:
          averagePointsPerGame ?? this.averagePointsPerGame,
      bestGamePoints: bestGamePoints ?? this.bestGamePoints,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      capicuas: capicuas ?? this.capicuas,
      zapateros: zapateros ?? this.zapateros,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gamesPlayed': gamesPlayed,
      'gamesFinished': gamesFinished,
      'totalRounds': totalRounds,
      'totalPoints': totalPoints,
      'averagePointsPerGame': averagePointsPerGame,
      'bestGamePoints': bestGamePoints,
      'wins': wins,
      'losses': losses,
      'capicuas': capicuas,
      'zapateros': zapateros,
    };
  }

  factory PlayerStats.fromMap(Map<String, dynamic> map) {
    return PlayerStats(
      gamesPlayed: (map['gamesPlayed'] as num?)?.toInt() ?? 0,
      gamesFinished: (map['gamesFinished'] as num?)?.toInt() ?? 0,
      totalRounds: (map['totalRounds'] as num?)?.toInt() ?? 0,
      totalPoints: (map['totalPoints'] as num?)?.toInt() ?? 0,
      averagePointsPerGame:
          (map['averagePointsPerGame'] as num?)?.toDouble() ?? 0,
      bestGamePoints: (map['bestGamePoints'] as num?)?.toInt() ?? 0,
      wins: (map['wins'] as num?)?.toInt() ?? 0,
      losses: (map['losses'] as num?)?.toInt() ?? 0,
      capicuas: (map['capicuas'] as num?)?.toInt() ?? 0,
      zapateros: (map['zapateros'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    gamesPlayed,
    gamesFinished,
    totalRounds,
    totalPoints,
    averagePointsPerGame,
    bestGamePoints,
    wins,
    losses,
    capicuas,
    zapateros,
  ];
}
