part of 'game_bloc.dart';

class GameState extends Equatable {
  final bool isLoading;
  final Game? currentGame;
  final List<Game> games;
  final List<int> selectPointsToWin;

  /// Modo de partida actual (equipos 2v2 / individual 2-3-4).
  final GameMode gameMode;

  /// Grupo activo: `null` = partidas locales (historial general).
  final String? activeGroupId;

  /// Valor de "puntos para ganar" (pendiente de aplicar o ya aplicado).
  final int pointsToWin;
  final int? pointToWinSelected;

  final Team? winnerTeam;
  final int? roundSelected;

  final String? errorMessage;

  const GameState({
    this.isLoading = true,
    this.currentGame,
    this.games = const [],
    this.selectPointsToWin = const [100, 200, 300],
    this.gameMode = GameMode.teams2v2,
    this.activeGroupId,
    this.pointsToWin = 0,
    this.pointToWinSelected,
    this.winnerTeam,
    this.roundSelected,
    this.errorMessage,
  });

  /// Cantidad de equipos de la partida actual.
  int get teamCount => currentGame?.teams.length ?? 0;

  bool get isGroupGame => activeGroupId != null;

  static const Object _unset = Object();

  GameState copyWith({
    bool? isLoading,
    Object? currentGame = _unset,
    List<Game>? games,
    List<int>? selectPointsToWin,
    GameMode? gameMode,
    Object? activeGroupId = _unset,
    int? pointsToWin,
    Object? pointToWinSelected = _unset,
    Object? winnerTeam = _unset,
    Object? roundSelected = _unset,
    Object? errorMessage = _unset,
  }) {
    return GameState(
      isLoading: isLoading ?? this.isLoading,
      currentGame: identical(currentGame, _unset)
          ? this.currentGame
          : currentGame as Game?,
      games: games ?? this.games,
      selectPointsToWin: selectPointsToWin ?? this.selectPointsToWin,
      gameMode: gameMode ?? this.gameMode,
      activeGroupId: identical(activeGroupId, _unset)
          ? this.activeGroupId
          : activeGroupId as String?,
      pointsToWin: pointsToWin ?? this.pointsToWin,
      pointToWinSelected: identical(pointToWinSelected, _unset)
          ? this.pointToWinSelected
          : pointToWinSelected as int?,
      winnerTeam: identical(winnerTeam, _unset)
          ? this.winnerTeam
          : winnerTeam as Team?,
      roundSelected: identical(roundSelected, _unset)
          ? this.roundSelected
          : roundSelected as int?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    currentGame,
    games,
    selectPointsToWin,
    gameMode,
    activeGroupId,
    pointsToWin,
    pointToWinSelected,
    winnerTeam,
    roundSelected,
    errorMessage,
  ];
}
