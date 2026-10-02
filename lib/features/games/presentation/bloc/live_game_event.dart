part of 'live_game_bloc.dart';

sealed class LiveGameEvent extends Equatable {
  const LiveGameEvent();

  @override
  List<Object?> get props => [];
}

/// Busca la partida con [code] y empieza a refrescarla sola.
class LiveGameWatched extends LiveGameEvent {
  final String code;

  const LiveGameWatched({required this.code});

  @override
  List<Object?> get props => [code];
}

/// Vuelve a pedir la partida (lo dispara el temporizador o el botón).
class LiveGameRefreshed extends LiveGameEvent {
  const LiveGameRefreshed();
}

/// Reabre la última partida en vivo que se vio, si todavía existe.
class LiveGameRestored extends LiveGameEvent {
  const LiveGameRestored();
}
