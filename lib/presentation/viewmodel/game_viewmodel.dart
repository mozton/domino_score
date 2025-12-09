import 'package:dominos_score/domain/models/game/round_model.dart';
import 'package:dominos_score/domain/models/game/team_model.dart';
import 'package:dominos_score/domain/models/models.dart';

import 'package:dominos_score/domain/repositories/game_repository.dart';
import 'package:flutter/material.dart';

class GameViewmodel extends ChangeNotifier {
  final GameRepository _repository;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  late GameModel _currentGame = GameModel(
    actualRound: 0,
    pointsToWin: 0,
    createdAt: DateTime.now(),
    teams: [],
    rounds: [],
  );
  GameModel get currentGame => _currentGame;

  // ======================== Points ======================== //

  int pointsToWin = 200;

  final List<int> _selectPointToWin = [100, 200, 300];
  List<int> get selectPointsToWin => _selectPointToWin;

  int? _pointToWinSelected = -1;
  int? get pointToWinSelected => _pointToWinSelected;

  void selectedPointsToWin(int isSelected) {
    _pointToWinSelected = isSelected;
    print(pointsToWin);
    notifyListeners();
  }

  Future<void> changePointToWin() async {
    await _repository.updateGamePointsToWin(currentGame.id!, pointsToWin);

    _currentGame.pointsToWin = pointsToWin;
    notifyListeners();
  }
  // ======================== Constructor ======================== //

  GameViewmodel(this._repository) {
    initGameOnStartup();
  }

  // ======================== Inicialización ======================== //

  Future<void> initGameOnStartup() async {
    _isLoading = true;
    notifyListeners();

    try {
      final existingGamen = await _repository.fetchAllGames();

      if (existingGamen.isEmpty) {
        await _createNewGame();

        // print("Juego nuevo creado con ID: ${_currentGame.id}");
      } else {
        _currentGame = existingGamen.last;
        // print("Juego existente cargado: ID ${_currentGame.id}");
      }
    } catch (e) {
      // print('Error al inicializar el juego: $e');
      _currentGame = GameModel(
        actualRound: 0,
        pointsToWin: pointsToWin,
        createdAt: DateTime.now(),
        teams: [],
        rounds: [],
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _createNewGame() async {
    final newGame = GameModel(
      actualRound: 0,
      pointsToWin: pointsToWin,
      createdAt: DateTime.now(),
      teams: [],
      rounds: [],
    );

    final fullGame = await _repository.createGameWithDefaultTeams(newGame);

    _currentGame = fullGame;
  }
  // ======================== //  GAMES  // ======================= //

  Future<void> startNewGame() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _createNewGame();
      resetWinnerState();
      _roundSelected = null;
    } catch (e) {
      print('Error al iniciar un nuevo juego: $e');
      // Manejar el error si la creación falla
    }
    _isLoading = false;
    notifyListeners();
  }

  // En GameViewmodel (dentro de la clase GameViewmodel)

  Future<void> startNewGameWithCurrentTeams() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. 💾 Capturar los detalles de los equipos actuales (nombre, jugadores)
      print('🔍 Capturando equipos para nuevo juego:');
      for (var team in _currentGame.teams) {
        print('  - Equipo: ${team.name} (ID: ${team.id})');
      }

      final currentTeamsDetails = _currentGame.teams.map((team) {
        // Creamos nuevos TeamModel con puntaje 0, sin ID (se asignará en la DB)
        return TeamModel(
          gameId: -1, // Temporal
          name: team.name,
          player1: team.player1,
          player2: team.player2,
          totalScore: 0, // Reiniciar score
        );
      }).toList();

      // 2. 🎮 Crear el nuevo GameModel
      final newGame = GameModel(
        actualRound: 0,
        pointsToWin:
            _currentGame.pointsToWin, // Mantiene la meta de puntos actual
        createdAt: DateTime.now(),
        teams: currentTeamsDetails, // Usamos los equipos reseteados
        rounds: [],
      );

      // 3. 📦 Persistir el nuevo juego y sus equipos en la DB
      final fullGame = await _repository.createGameWithDefaultTeams(newGame);

      // 4. 🔄 Actualizar el estado interno
      _currentGame = fullGame;

      // 5. 🧹 Limpiar estados anteriores del juego
      resetWinnerState();
      _roundSelected = null;
    } catch (e) {
      print('Error al iniciar un nuevo juego con equipos actuales: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadGameDetails(int gameId) async {
    try {
      final games = await _repository.fetchAllGames();
      _currentGame = games.last;
      notifyListeners();
    } catch (e) {
      print('Error al cargar los detalles del juego: $e');
    }
  }

  void resetWinnerState() {
    _winnerTeam = null;
  }

  // ======================== //  TEAMS  // ======================= //

  TeamModel? _winnerTeam;
  TeamModel? get winnerTeam => _winnerTeam;
  void _handleGameEnd({required TeamModel winningTeam}) {
    // 1. Guarda el estado del ganador
    _winnerTeam = winningTeam;

    // 2. Opcional: Marcar el juego como terminado en la DB

    // 3. Notificar a los listeners para que la UI reaccione
    notifyListeners();
  }

  Future<void> addTeam(TeamModel team) async {
    final gameId = _currentGame.id!;
    final teamId = await _repository.insertTeam(gameId, team);

    final newTeam = TeamModel(
      id: teamId,
      gameId: gameId,
      name: team.name,
      player1: team.player1,
      player2: team.player2,
      totalScore: team.totalScore,
    );

    _currentGame.teams.add(newTeam);

    notifyListeners();
  }

  Future<void> updateTeamName(int teamId, String newName) async {
    final result = await _repository.updateTeamName(teamId, newName);

    if (result > 0) {
      final updateTeamList = _currentGame.teams.map((team) {
        if (team.id == teamId) {
          return TeamModel(
            id: team.id,
            gameId: team.gameId,
            name: newName,
            player1: team.player1,
            player2: team.player2,
            totalScore: team.totalScore,
          );
        }
        return team;
      }).toList();
      _currentGame.teams = updateTeamList;
      notifyListeners();
    }
  }

  // ======================== ROUNDS ======================== //

  int get totalTeam1Points => currentGame.teams[0].totalScore;
  int get totalTeam2Points => currentGame.teams[1].totalScore;

  Future<void> addRound(RoundModel newRound) async {
    final gameId = _currentGame.id!;

    final nextRoundNumber = _currentGame.actualRound + 1;

    final team1 = _currentGame.teams[0];
    final team2 = _currentGame.teams[1];

    final newTeam1Score = team1.totalScore + newRound.team1Points;
    final newTeam2Score = team2.totalScore + newRound.team2Points;

    final roundToSave = RoundModel(
      number: nextRoundNumber,
      gameId: gameId,
      team1Points: newRound.team1Points,
      team2Points: newRound.team2Points,
    );
    try {
      // ======================= PERISTENCIA (3 Llamadas a DB) ======================= //

      // A. Insertar la nueva ronda (obteniendo el ID)
      final roundId = await _repository.saveRound(gameId, roundToSave);

      // B. Actualizar el totalScore de los equipos
      await _repository.updateTeamScore(team1.id!, newTeam1Score);
      await _repository.updateTeamScore(team2.id!, newTeam2Score);

      // C. Actualizar el número de ronda actual del juego
      await _repository.updateGameActualRound(gameId, nextRoundNumber);

      // ======================= ACTUALIZACIÓN DE ESTADO (Memoria) ======================= //

      // 3. Crear el objeto RoundModel completo y agregarlo
      final finalRound = RoundModel(
        id: roundId,
        number: nextRoundNumber,
        team1Points: newRound.team1Points,
        team2Points: newRound.team2Points,
        gameId: gameId,
      ); // Reconstruir con ID
      _currentGame.rounds.add(finalRound);

      // 4. Actualizar el actualRound del juego
      _currentGame.actualRound = nextRoundNumber;

      // 5. Actualizar el totalScore de los objetos TeamModel en _currentGame
      _currentGame.teams[0] = team1.copyWith(totalScore: newTeam1Score);
      _currentGame.teams[1] = team2.copyWith(totalScore: newTeam2Score);

      final pointsGoal = _currentGame.pointsToWin;

      if (newTeam1Score >= pointsGoal && pointsGoal > 0) {
        _handleGameEnd(winningTeam: _currentGame.teams[0]);
        return;
      } else if (newTeam2Score >= pointsGoal && pointsGoal > 0) {
        _handleGameEnd(winningTeam: _currentGame.teams[1]);
        return;
      }

      // 6. Notificar a la UI
      notifyListeners();
    } catch (e) {
      // print('Error al añadir ronda y actualizar scores: $e');
      // Manejar el error, tal vez mostrar un Toast o un diálogo.
    }
  }

  // Selected Round
  int? _roundSelected;
  int? get roundSelected => _roundSelected;

  Future<void> selectedRoundByIndex(int? index) async {
    // print('Selected round index: $index');
    _roundSelected = index;
    notifyListeners();
  }

  // Delete Round

  Future<void> deleteSelectedRound() async {
    if (_roundSelected == null) {
      return;
    }

    if (_currentGame.rounds.isEmpty ||
        _roundSelected! >= _currentGame.rounds.length) {
      _roundSelected = null;
      notifyListeners();
      return;
    }

    final roundToDelete = _currentGame.rounds[_roundSelected!];
    final roundId = roundToDelete.id!;

    // 1. Obtener equipos y calcular nuevos puntajes
    final team1 = _currentGame.teams[0];
    final team2 = _currentGame.teams[1];

    final newTeam1Score = team1.totalScore - roundToDelete.team1Points;
    final newTeam2Score = team2.totalScore - roundToDelete.team2Points;

    // 2. Decrementar el número de ronda actual
    final newActualRound = _currentGame.actualRound - 1;

    try {
      // 3. Actulizar DB
      // A. Actualizar scores en DB
      await _repository.updateTeamScore(team1.id!, newTeam1Score);
      await _repository.updateTeamScore(team2.id!, newTeam2Score);

      // B. Actualizar actualRound en DB
      await _repository.updateGameActualRound(
        _currentGame.id!,
        newActualRound < 0 ? 0 : newActualRound,
      );

      // C. Eliminar la ronda
      await _repository.deleteRound(roundId);

      // 4. Recargar estado completo del juego
      await loadGameDetails(_currentGame.id!);

      _roundSelected = null;
      notifyListeners();
    } catch (e) {
      print('Error al eliminar ronda: $e');
    }
  }

  //
}
