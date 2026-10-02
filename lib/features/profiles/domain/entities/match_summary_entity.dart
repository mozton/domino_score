import 'package:equatable/equatable.dart';

/// Resumen de una partida para el historial del perfil.
class MatchSummary extends Equatable {
  final int gameId;
  final String title;
  final String scoreDetail;
  final DateTime date;

  /// Si el jugador ganó. `null` mientras la jugabilidad no registre a quién
  /// pertenece cada equipo.
  final bool? wonByMe;
  final bool finished;

  const MatchSummary({
    required this.gameId,
    required this.title,
    required this.scoreDetail,
    required this.date,
    this.wonByMe,
    this.finished = false,
  });

  @override
  List<Object?> get props => [
    gameId,
    title,
    scoreDetail,
    date,
    wonByMe,
    finished,
  ];
}
