import 'package:equatable/equatable.dart';

class GroupMemberEntity extends Equatable {
  final String id;
  final bool isGuest; // true si no tiene cuenta en la app aún
  final String displayName;
  final String nickname;
  final String? avatarUrl;
  final int level;
  final int gamesPlayed;
  final int wins;
  final int losses;
  final int capicuasCount;
  final int zapaterosCount;
  final int totalPoints;
  final int currentStreak;
  final List<String> unlockedBadges;
  final DateTime joinedAt;

  const GroupMemberEntity({
    required this.id,
    required this.isGuest,
    required this.displayName,
    required this.nickname,
    this.avatarUrl,
    this.level = 1,
    this.gamesPlayed = 0,
    this.wins = 0,
    this.losses = 0,
    this.capicuasCount = 0,
    this.zapaterosCount = 0,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.unlockedBadges = const [],
    required this.joinedAt,
  });

  double get winRate => gamesPlayed > 0 ? (wins / gamesPlayed) * 100 : 0.0;

  @override
  List<Object?> get props => [
    id,
    isGuest,
    displayName,
    nickname,
    avatarUrl,
    level,
    gamesPlayed,
    wins,
    losses,
    capicuasCount,
    zapaterosCount,
    totalPoints,
    currentStreak,
    unlockedBadges,
    joinedAt,
  ];
}
