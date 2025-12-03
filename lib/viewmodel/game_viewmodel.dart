import 'package:dominos_score/models/game/round_model.dart';
import 'package:dominos_score/models/game/team_model.dart';
import 'package:dominos_score/models/models.dart';
import 'package:dominos_score/repository/game_repository.dart';
import 'package:flutter/material.dart';

class GameViewmodel extends ChangeNotifier {
  final GameRepository _repository;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  late GameModel _currentGame = GameModel(
    actualRound: 0,
    pointsToWin: pointsToWin,
    createdAt: DateTime.now(),
    teams: [],
    rounds: [],
  );
  GameModel get currentGame => _currentGame;

  int pointsToWin = 200;

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

  Future<void> loadGameDetails(int gameId) async {
    try {
      // 1. Obtener el GameModel completo (que ya incluye 'rounds')
      final games = await _repository.fetchAllGames();

      // 2. 🎯 Actualizar el estado interno
      _currentGame = games.last;

      // 3. Notificar a la UI
      notifyListeners();
    } catch (e) {
      print('Error al cargar los detalles del juego: $e');
    }
  }

  // ======================== //  TEAMS  // ======================= //

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
      currentGame.teams = updateTeamList;
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

      // 6. Notificar a la UI
      notifyListeners();
    } catch (e) {
      print('Error al añadir ronda y actualizar scores: $e');
      // Manejar el error, tal vez mostrar un Toast o un diálogo.
    }
  }

  // Selected Round
  int? _roundSelected;
  int? get roundSelected => _roundSelected;

  Future<void> selectedRoundByIndex(int? index) async {
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
    final roundId = _currentGame.rounds[_roundSelected!].id;

    await _repository.deleteRound(roundId!);

    await loadGameDetails(_currentGame.id!);
    _roundSelected = null;
    notifyListeners();
  }
}
