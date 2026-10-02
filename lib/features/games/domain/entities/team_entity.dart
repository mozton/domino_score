import 'package:equatable/equatable.dart';

/// Entidad de dominio de un equipo dentro de una partida.
class Team extends Equatable {
  final int? id;
  final int? gameId;
  final String name;
  final String? player1;
  final String? player2;
  final int totalScore;

  const Team({
    this.id,
    this.gameId,
    required this.name,
    this.player1,
    this.player2,
    required this.totalScore,
  });

  Team copyWith({
    int? id,
    int? gameId,
    String? name,
    String? player1,
    String? player2,
    int? totalScore,
  }) {
    return Team(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      name: name ?? this.name,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      totalScore: totalScore ?? this.totalScore,
    );
  }

  @override
  List<Object?> get props => [id, gameId, name, player1, player2, totalScore];
}
