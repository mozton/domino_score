import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/game_mode.dart';
import 'package:dominos_score/features/games/domain/entities/live_game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';
import 'package:dominos_score/features/games/domain/game_scope.dart';
import 'package:dominos_score/features/games/domain/usecases/add_round_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/delete_round_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/generate_live_code_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/init_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/load_games_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/publish_live_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/rename_team_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/save_live_code_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/set_my_team_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/start_new_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/start_new_game_with_teams_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/update_points_to_win_usecase.dart';
import 'package:dominos_score/features/settings/domain/repositories/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

/// BLoC del marcador de dominó. Orquesta los casos de uso del dominio y expone
/// el estado que consumen las pantallas.
class GameBloc extends Bloc<GameEvent, GameState> {
  final InitGameUseCase _initGame;
  final LoadGamesUseCase _loadGames;
  final StartNewGameUseCase _startNewGame;
  final StartNewGameWithTeamsUseCase _startNewGameWithTeams;
  final AddRoundUseCase _addRound;
  final DeleteRoundUseCase _deleteRound;
  final RenameTeamUseCase _renameTeam;
  final SetMyTeamUseCase _setMyTeam;
  final UpdatePointsToWinUseCase _updatePointsToWin;
  final PublishLiveGameUseCase _publishLiveGame;
  final SaveLiveCodeUseCase _saveLiveCode;
  final GenerateLiveCodeUseCase _generateLiveCode;
  final SettingsRepository _settingsRepository;
  final GameScope _scope;

  GameBloc({
    required InitGameUseCase initGame,
    required LoadGamesUseCase loadGames,
    required StartNewGameUseCase startNewGame,
    required StartNewGameWithTeamsUseCase startNewGameWithTeams,
    required AddRoundUseCase addRound,
    required DeleteRoundUseCase deleteRound,
    required RenameTeamUseCase renameTeam,
    required SetMyTeamUseCase setMyTeam,
    required UpdatePointsToWinUseCase updatePointsToWin,
    required PublishLiveGameUseCase publishLiveGame,
    required SaveLiveCodeUseCase saveLiveCode,
    required GenerateLiveCodeUseCase generateLiveCode,
    required SettingsRepository settingsRepository,
    required GameScope scope,
  }) : _initGame = initGame,
       _loadGames = loadGames,
       _startNewGame = startNewGame,
       _startNewGameWithTeams = startNewGameWithTeams,
       _addRound = addRound,
       _deleteRound = deleteRound,
       _renameTeam = renameTeam,
       _setMyTeam = setMyTeam,
       _updatePointsToWin = updatePointsToWin,
       _publishLiveGame = publishLiveGame,
       _saveLiveCode = saveLiveCode,
       _generateLiveCode = generateLiveCode,
       _settingsRepository = settingsRepository,
       _scope = scope,
       super(const GameState()) {
    on<GameInitialized>(_onInit);
    on<GroupGameStarted>(_onGroupGameStarted);
    on<GamesLoaded>(_onLoadGames);
    on<NewGameStarted>(_onStartNewGame);
    on<GameModeSelected>(_onGameModeSelected);
    on<NewGameWithTeamsStarted>(_onStartNewGameWithTeams);
    on<RoundAdded>(_onAddRound);
    on<RoundSelected>(_onSelectRound);
    on<SelectedRoundDeleted>(_onDeleteSelectedRound);
    on<TeamRenamed>(_onRenameTeam);
    on<MyTeamSelected>(_onMyTeamSelected);
    on<PointsToWinSelected>(_onSelectPointsToWin);
    on<PointsToWinChanged>(_onChangePointsToWin);
    on<WinnerReset>(_onResetWinner);
  }

  Future<void> _onInit(GameInitialized event, Emitter<GameState> emit) async {
    // Cambia el alcance: partidas locales o las de un grupo concreto.
    _scope.setGroup(event.groupId, groupName: event.groupName);

    emit(
      state.copyWith(
        isLoading: true,
        activeGroupId: event.groupId,
        errorMessage: null,
      ),
    );
    final points = await _settingsRepository.getPointToWin() ?? 0;
    final mode = GameMode.fromName(
      await _settingsRepository.getGameModeName(),
    );
    // En un grupo cada partida tiene su código para verla en vivo.
    final liveCode = _scope.isGroup ? await _generateLiveCode() : null;
    try {
      var game = await _initGame(
        pointsToWin: points,
        mode: mode,
        liveCode: liveCode,
      );
      game = await _attachLiveCode(game, liveCode);
      emit(
        state.copyWith(
          isLoading: false,
          currentGame: game,
          pointsToWin: points,
          gameMode: mode,
          activeGroupId: event.groupId,
          winnerTeam: null,
          roundSelected: null,
        ),
      );
      await _publishLive(game);
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          gameMode: mode,
          activeGroupId: event.groupId,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGroupGameStarted(
    GroupGameStarted event,
    Emitter<GameState> emit,
  ) async {
    _scope.setGroup(event.groupId, groupName: event.groupName);

    emit(
      state.copyWith(
        isLoading: true,
        currentGame: null,
        activeGroupId: event.groupId,
        gameMode: event.mode,
        winnerTeam: null,
        roundSelected: null,
        errorMessage: null,
      ),
    );
    try {
      final game = await _startNewGame(
        pointsToWin: state.pointsToWin,
        mode: event.mode,
        liveCode: await _generateLiveCode(),
      );
      emit(state.copyWith(isLoading: false, currentGame: game));
      await _publishLive(game);
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onLoadGames(GamesLoaded event, Emitter<GameState> emit) async {
    final games = await _loadGames();
    emit(state.copyWith(games: games));
  }

  Future<void> _onStartNewGame(
    NewGameStarted event,
    Emitter<GameState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final game = await _startNewGame(
        pointsToWin: state.pointsToWin,
        mode: event.mode,
        liveCode: _scope.isGroup ? await _generateLiveCode() : null,
      );
      emit(
        state.copyWith(
          isLoading: false,
          currentGame: game,
          gameMode: event.mode,
          winnerTeam: null,
          roundSelected: null,
        ),
      );
      await _publishLive(game);
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onGameModeSelected(
    GameModeSelected event,
    Emitter<GameState> emit,
  ) async {
    await _settingsRepository.saveGameModeName(event.mode.name);
    // Aplica el modo reiniciando la partida con la nueva cantidad de equipos.
    add(NewGameStarted(event.mode));
  }

  Future<void> _onStartNewGameWithTeams(
    NewGameWithTeamsStarted event,
    Emitter<GameState> emit,
  ) async {
    final current = state.currentGame;
    if (current == null) return;

    emit(state.copyWith(isLoading: true));
    try {
      final game = await _startNewGameWithTeams(
        current,
        liveCode: _scope.isGroup ? await _generateLiveCode() : null,
      );
      emit(
        state.copyWith(
          isLoading: false,
          currentGame: game,
          winnerTeam: null,
          roundSelected: null,
        ),
      );
      await _publishLive(game);
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onAddRound(RoundAdded event, Emitter<GameState> emit) async {
    final game = state.currentGame;
    if (game == null || game.id == null || game.teams.length < 2) return;

    try {
      final updated = await _addRound(
        game,
        teamPoints: event.teamPoints,
        events: event.events,
      );

      Team? winner;
      final goal = updated.pointsToWin;
      if (goal > 0) {
        for (final team in updated.teams) {
          if (team.totalScore >= goal) {
            winner = team;
            break;
          }
        }
      }

      emit(state.copyWith(currentGame: updated, winnerTeam: winner));
      await _publishLive(updated);
    } catch (_) {
      // Ignorar errores, igual que el viewmodel anterior.
    }
  }

  void _onSelectRound(RoundSelected event, Emitter<GameState> emit) {
    emit(state.copyWith(roundSelected: event.index));
  }

  Future<void> _onDeleteSelectedRound(
    SelectedRoundDeleted event,
    Emitter<GameState> emit,
  ) async {
    final index = state.roundSelected;
    final game = state.currentGame;
    if (index == null ||
        game == null ||
        game.rounds.isEmpty ||
        index >= game.rounds.length) {
      emit(state.copyWith(roundSelected: null));
      return;
    }

    try {
      final updated = await _deleteRound(game, roundIndex: index);
      emit(state.copyWith(currentGame: updated, roundSelected: null));
      await _publishLive(updated);
    } catch (_) {
      // Ignorar errores.
    }
  }

  Future<void> _onRenameTeam(TeamRenamed event, Emitter<GameState> emit) async {
    await _renameTeam(event.teamId, event.newName);

    final game = state.currentGame;
    if (game != null) {
      final updated = game.copyWith(
        teams: game.teams
            .map(
              (t) => t.id == event.teamId
                  ? t.copyWith(name: event.newName)
                  : t,
            )
            .toList(),
      );
      emit(state.copyWith(currentGame: updated));
      await _publishLive(updated);
    }
  }

  Future<void> _onMyTeamSelected(
    MyTeamSelected event,
    Emitter<GameState> emit,
  ) async {
    final game = state.currentGame;
    if (game == null) return;

    try {
      await _setMyTeam(game, event.teamIndex);
      // Se reconstruye para permitir limpiar el equipo (null).
      final updated = Game(
        id: game.id,
        actualRound: game.actualRound,
        pointsToWin: game.pointsToWin,
        createdAt: game.createdAt,
        winnerTeamName: game.winnerTeamName,
        teams: game.teams,
        rounds: game.rounds,
        myTeamIndex: event.teamIndex,
        liveCode: game.liveCode,
      );
      emit(state.copyWith(currentGame: updated, errorMessage: null));
      await _publishLive(updated);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onSelectPointsToWin(
    PointsToWinSelected event,
    Emitter<GameState> emit,
  ) async {
    await _settingsRepository.savePointToWin(event.points);
    emit(
      state.copyWith(pointsToWin: event.points, pointToWinSelected: event.points),
    );
  }

  Future<void> _onChangePointsToWin(
    PointsToWinChanged event,
    Emitter<GameState> emit,
  ) async {
    final game = state.currentGame;
    if (game == null || game.id == null) return;

    final updated = await _updatePointsToWin(game.id!, state.pointsToWin);
    emit(state.copyWith(currentGame: updated));
    await _publishLive(updated);
  }

  /// Asegura que la partida de un grupo tenga un código en vivo.
  ///
  /// Las partidas creadas antes de esta función no lo tienen, así que se les
  /// asigna uno y se guarda para que no cambie en cada apertura.
  Future<Game> _attachLiveCode(Game game, String? candidate) async {
    if (!_scope.isGroup || candidate == null) return game;

    final existing = game.liveCode;
    if (existing != null && existing.isNotEmpty) return game;

    try {
      await _saveLiveCode(game, candidate);
    } catch (_) {
      // Si no se puede guardar, el código igual sirve para esta sesión.
    }
    return game.copyWith(liveCode: candidate);
  }

  /// Sube el estado actual a `liveGames/{code}` para que los invitados lo vean.
  ///
  /// Es "best effort": si falla (sin red, reglas, etc.) el marcador local sigue
  /// funcionando igual.
  Future<void> _publishLive(Game game) async {
    final groupId = _scope.groupId;
    final code = game.liveCode;
    if (groupId == null || code == null || code.isEmpty) return;

    try {
      await _publishLiveGame(
        LiveGame(
          code: code,
          groupId: groupId,
          groupName: _scope.groupName ?? '',
          game: game,
          updatedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      // La vista en vivo es un extra; nunca debe romper el juego.
    }
  }

  void _onResetWinner(WinnerReset event, Emitter<GameState> emit) {
    emit(state.copyWith(winnerTeam: null));
  }

  // Getters de conveniencia para la UI (equivalen a los del viewmodel).
  Game? get currentGame => state.currentGame;
  List<Game> get games => state.games;
  int? get roundSelected => state.roundSelected;
  Team? get winnerTeam => state.winnerTeam;
  List<int> get selectPointsToWin => state.selectPointsToWin;
  int? get pointToWinSelected => state.pointToWinSelected;
}
