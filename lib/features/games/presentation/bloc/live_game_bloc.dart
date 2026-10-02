import 'dart:async';

import 'package:dominos_score/features/games/data/datasources/last_live_code_store.dart';
import 'package:dominos_score/features/games/domain/entities/live_game_entity.dart';
import 'package:dominos_score/features/games/domain/usecases/get_live_game_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'live_game_event.dart';
part 'live_game_state.dart';

/// BLoC de la vista en vivo de una partida de grupo.
///
/// Firestore por REST no tiene tiempo real, así que se refresca sola cada
/// [refreshInterval] mientras la pantalla está abierta.
class LiveGameBloc extends Bloc<LiveGameEvent, LiveGameState> {
  /// Cada cuánto se vuelve a pedir la partida.
  static const Duration refreshInterval = Duration(seconds: 5);

  final GetLiveGameUseCase _getLiveGame;
  final LastLiveCodeStore _lastLiveCode;
  Timer? _timer;

  LiveGameBloc({
    required GetLiveGameUseCase getLiveGame,
    LastLiveCodeStore? lastLiveCodeStore,
  }) : _getLiveGame = getLiveGame,
       _lastLiveCode = lastLiveCodeStore ?? const NoLastLiveCodeStore(),
       super(const LiveGameState()) {
    on<LiveGameWatched>(_onWatched);
    on<LiveGameRefreshed>(_onRefreshed);
    on<LiveGameRestored>(_onRestored);
  }

  /// Vuelve a abrir la última partida vista.
  ///
  /// Si la partida ya no existe, solo se deja el código escrito en el campo
  /// para que el invitado no tenga que teclearlo otra vez.
  Future<void> _onRestored(
    LiveGameRestored event,
    Emitter<LiveGameState> emit,
  ) async {
    final saved = await _lastLiveCode.read();
    if (saved == null || saved.trim().isEmpty) return;

    final code = saved.trim().replaceAll('#', '').toUpperCase();
    try {
      final live = await _getLiveGame(code);
      if (live == null) {
        emit(LiveGameState(status: LiveGameStatus.idle, code: code));
        return;
      }
      emit(
        LiveGameState(
          status: LiveGameStatus.loaded,
          code: code,
          liveGame: live,
          lastUpdate: DateTime.now(),
        ),
      );
      _startTimer();
    } catch (_) {
      emit(LiveGameState(status: LiveGameStatus.idle, code: code));
    }
  }

  Future<void> _onWatched(
    LiveGameWatched event,
    Emitter<LiveGameState> emit,
  ) async {
    _timer?.cancel();

    final code = event.code.trim().replaceAll('#', '').toUpperCase();
    if (code.isEmpty) {
      emit(
        const LiveGameState(
          status: LiveGameStatus.idle,
          errorMessage: 'Escribe el código de la partida.',
        ),
      );
      return;
    }

    emit(
      LiveGameState(
        status: LiveGameStatus.loading,
        code: code,
      ),
    );

    try {
      final live = await _getLiveGame(code);
      if (live == null) {
        emit(
          LiveGameState(
            status: LiveGameStatus.notFound,
            code: code,
            errorMessage: 'No hay ninguna partida con el código $code.',
          ),
        );
        return;
      }

      emit(
        LiveGameState(
          status: LiveGameStatus.loaded,
          code: code,
          liveGame: live,
          lastUpdate: DateTime.now(),
        ),
      );
      // Se recuerda para poder volver a esta partida sin escribir el código.
      await _lastLiveCode.save(code);
      _startTimer();
    } catch (e) {
      emit(
        LiveGameState(
          status: LiveGameStatus.error,
          code: code,
          errorMessage: 'No se pudo cargar la partida: $e',
        ),
      );
    }
  }

  Future<void> _onRefreshed(
    LiveGameRefreshed event,
    Emitter<LiveGameState> emit,
  ) async {
    final code = state.code;
    if (state.status != LiveGameStatus.loaded || code == null || code.isEmpty) {
      return;
    }

    try {
      final live = await _getLiveGame(code);
      if (live == null) {
        _timer?.cancel();
        emit(
          state.copyWith(
            status: LiveGameStatus.notFound,
            errorMessage: 'La partida ya no está disponible.',
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          liveGame: live,
          lastUpdate: DateTime.now(),
          clearError: true,
        ),
      );
    } catch (_) {
      // Sin conexión: se conserva lo último que se vio.
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(refreshInterval, (_) {
      if (!isClosed) add(const LiveGameRefreshed());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timer = null;
    return super.close();
  }
}
