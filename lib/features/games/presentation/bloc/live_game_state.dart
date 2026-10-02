part of 'live_game_bloc.dart';

enum LiveGameStatus { idle, loading, loaded, notFound, error }

class LiveGameState extends Equatable {
  final LiveGameStatus status;
  final String? code;
  final LiveGame? liveGame;
  final String? errorMessage;
  final DateTime? lastUpdate;

  const LiveGameState({
    this.status = LiveGameStatus.idle,
    this.code,
    this.liveGame,
    this.errorMessage,
    this.lastUpdate,
  });

  LiveGameState copyWith({
    LiveGameStatus? status,
    String? code,
    LiveGame? liveGame,
    String? errorMessage,
    bool clearError = false,
    DateTime? lastUpdate,
  }) {
    return LiveGameState(
      status: status ?? this.status,
      code: code ?? this.code,
      liveGame: liveGame ?? this.liveGame,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  bool get isLoading => status == LiveGameStatus.loading;

  @override
  List<Object?> get props => [status, code, liveGame, errorMessage, lastUpdate];
}
