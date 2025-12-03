import 'package:dominos_score/models/models.dart';
import 'package:dominos_score/models/game/game_model.dart';
import 'package:dominos_score/models/game/team_model.dart';
import 'package:dominos_score/models/game/round_model.dart';
import 'package:dominos_score/repository/game_repository.dart';
import 'package:dominos_score/services/local/database_helper.dart';
import 'package:flutter/material.dart';

class GamProvider extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final GameRepository _repository;

  int pointsToWin = 0;
  int get seletPointToWin => pointsToWin;

  late GameModel currentGame = GameModel(
    actualRound: 0,
    pointsToWin: 200,
    createdAt: DateTime.now(),
    teams: [],
    rounds: [],
  );
  List<GameModel> allGames = [];

  GamProvider(this._repository) {
    initGameOnStartup();
  }
  // ========================  Initialization  ======================== //

  Future<void> initGameOnStartup() async {
    // 💥 AVISO: Aún estás usando dbHelper.getGames() aquí.
    final games = await dbHelper.getGames();

    if (games.isNotEmpty) {
      currentGame = games.last;
      notifyListeners();
      return;
    }

    // 2. Si NO existe ningún juego → crear uno
    final newGame = GameModel(
      actualRound: 0,
      pointsToWin: 0,
      createdAt: DateTime.now(),
      teams: [],
      rounds: [] /* ... */,
    );
    final gameId = await dbHelper.createGame(newGame);
    newGame.id = gameId;

    // 4. Insertar equipos por defecto
    final team1 = TeamModel(
      gameId: gameId,
      name: "Team 1",
      totalScore: 0,
    ); // ID es null al insertar
    final team2 = TeamModel(gameId: gameId, name: "Team 2", totalScore: 0);

    // 5. Insertar en DB y OBTENER el ID de SQLite
    final team1Id = await dbHelper.insertTeam(gameId, team1);
    final team2Id = await dbHelper.insertTeam(gameId, team2);

    // 6. CREAR los modelos en memoria *SOLO UNA VEZ* con los IDs de SQLite
    newGame.teams.add(
      TeamModel(id: team1Id, gameId: gameId, name: "Team 1", totalScore: 0),
    );
    newGame.teams.add(
      TeamModel(id: team2Id, gameId: gameId, name: "Team 2", totalScore: 0),
    );

    currentGame = newGame;
    notifyListeners();
  }

  // Selected points To Win

  int? _pointSelect = -2;
  int? get pointToWinIsSelected => _pointSelect;

  void selectPointToWin(int isSelected) {
    _pointSelect = isSelected;
    notifyListeners();
  }

  // ======================== // GAMES //  ======================== //

  Future<void> createGame() async {
    // 1. Crear el objeto del juego sin ID
    final newGame = GameModel(
      actualRound: 0,
      pointsToWin: pointsToWin,
      createdAt: DateTime.now(),
      teams: [],
      rounds: [],
    );

    // 2. Crear el juego en la DB y obtener el ID generado
    final gameId = await dbHelper.createGame(newGame);

    // 3. Asignar el ID a tu modelo local
    newGame.id = gameId;

    // Save in provider
    currentGame = newGame;
    // print("Nuevo juego creado con ID: $gameId");

    notifyListeners();
  }

  Future<void> createGameOtherTeam() async {
    // 1. Crear el objeto del juego sin ID

    final newGame = GameModel(
      actualRound: 0,
      pointsToWin: pointsToWin,
      createdAt: DateTime.now(),
      teams: [],
      rounds: [],
    );

    // 2. Crear el juego en la DB y obtener el ID generado
    final gameId = await dbHelper.createGame(newGame);

    newGame.id = gameId;

    final team1 = TeamModel(
      id: null,
      gameId: gameId,
      name: "Team 1",
      totalScore: 0,
    );
    final team2 = TeamModel(
      id: null,
      gameId: gameId,
      name: "Team 2",
      totalScore: 0,
    );

    final team1Id = await dbHelper.insertTeam(gameId, team1);
    final team2Id = await dbHelper.insertTeam(gameId, team2);

    newGame.teams.add(
      TeamModel(id: team1Id, gameId: gameId, name: "Team 1", totalScore: 0),
    );

    newGame.teams.add(
      TeamModel(id: team2Id, gameId: gameId, name: "Team 2", totalScore: 0),
    );

    currentGame = newGame;

    print("Nuevo juego creado con ID: $gameId");

    notifyListeners();
  }

  Future<void> createGameSameTeam() async {
    // 1. Crear el objeto del juego sin ID

    final newGame = GameModel(
      actualRound: 0,
      pointsToWin: pointsToWin,
      createdAt: DateTime.now(),
      teams: [],
      rounds: [],
    );

    // 2. Crear el juego en la DB y obtener el ID generado
    final gameId = await dbHelper.createGame(newGame);

    // 3. Asignar el ID a tu modelo local
    newGame.id = gameId;

    final team1Name = currentGame.teams[0].name;
    final team2Name = currentGame.teams[1].name;
    final team1 = TeamModel(
      id: null,
      gameId: gameId,
      name: team1Name,
      totalScore: 0,
    );
    final team2 = TeamModel(
      id: null,
      gameId: gameId,
      name: team2Name,
      totalScore: 0,
    );

    final team1Id = await dbHelper.insertTeam(gameId, team1);
    final team2Id = await dbHelper.insertTeam(gameId, team2);

    newGame.teams.add(
      TeamModel(id: team1Id, gameId: gameId, name: team1Name, totalScore: 0),
    );

    newGame.teams.add(
      TeamModel(id: team2Id, gameId: gameId, name: team2Name, totalScore: 0),
    );

    currentGame = newGame;

    print("Nuevo juego creado con ID: $gameId");

    notifyListeners();
  }

  Future<void> updateScoreToWin() async {
    await dbHelper.updatePointToWin(currentGame.id!, pointsToWin);
    currentGame.pointsToWin = pointsToWin;

    notifyListeners();
  }
  // ============================== // TEAMS // ============================== //

  // Add Teams

  Future<void> addTeam(TeamModel team, int teamId) async {
    final gameId = currentGame.id;

    // 1. Insertar en DB y obtener el ID real
    final teamId = await dbHelper.insertTeam(gameId!, team);

    // 2. Crear un nuevo objeto Team con ese ID
    final newTeam = TeamModel(
      id: teamId,
      gameId: gameId,
      name: team.name,
      totalScore: 0,
    );

    currentGame.teams.add(newTeam);
    // print("Equipo agregado con ID $teamId al juego $gameId");

    notifyListeners();
  }

  // Asumimos que ya tienes la inyección de _repository
  Future<void> updateTeamName(int teamId, String newName) async {
    // 1. Persistencia: Llama al repositorio para guardar en la DB.
    final result = await _repository.updateTeamName(teamId, newName);

    // 2. Si se actualizó al menos una fila (result > 0)...
    if (result > 0) {
      // 3. Crear una nueva lista de equipos (patrón de inmutabilidad)
      final updatedTeamsList = currentGame.teams.map((team) {
        // Si encontramos el equipo, creamos una COPIA con el nuevo nombre y el resto de datos
        if (team.id == teamId) {
          return TeamModel(
            id: team.id,
            gameId: team.gameId,
            name: newName, // ⬅️ Nuevo Nombre
            // Asegúrate de copiar todos los demás campos
            player1: team.player1,
            player2: team.player2,
            totalScore: team.totalScore,
          );
        }
        // De lo contrario, devolvemos el equipo sin modificar
        return team;
      }).toList(); // Esto crea una nueva List<TeamModel>

      // 4. Reemplazar la lista en la memoria del estado.
      currentGame.teams = updatedTeamsList;

      // ¡PRUEBA CRÍTICA! (Mantenemos el print para el debug)
      // Usamos el índice seguro para obtener el nombre actualizado.
      final updatedName = currentGame.teams
          .firstWhere(
            (t) => t.id == teamId,
            orElse: () =>
                throw Exception("Equipo no encontrado después de actualizar"),
          )
          .name;

      print("Nombre en memoria justo antes de notificar: $updatedName");

      // 5. Notificar a la UI
      notifyListeners();
    }
  }

  // ======================== // Goblal Controllers // ======================== //

  final TextEditingController _pointController = TextEditingController();
  TextEditingController get pointController => _pointController;

  final TextEditingController _team1NameController = TextEditingController();
  TextEditingController get team1NameController => _team1NameController;

  final TextEditingController _team2NameController = TextEditingController();
  TextEditingController get team2NameController => _team2NameController;

  // Puntos totales
  final List<int> _pointsToWinList = [100, 200, 300];
  List<int> get pointsToWins => _pointsToWinList;

  // ======================== // ROUNDS // ======================== //

  //Add Round

  Future<void> addRound(int pointsTeam1, int pointsTeam2) async {
    final actualRound = currentGame.actualRound += 1;

    RoundModel newRound = RoundModel(
      number: actualRound,
      team1Points: pointsTeam1,
      team2Points: pointsTeam2,
    );

    currentGame.rounds.add(newRound);
    final int newId = await dbHelper.insertRound(currentGame.id!, newRound);

    newRound.id = newId;
    await dbHelper.updateActualRound(currentGame.id!, actualRound);

    notifyListeners();
  }

  // Delete points in round

  Future<void> deleteRound(int roundId) async {
    currentGame.rounds.removeWhere((r) {
      // print(r.id);
      return r.id == roundId;
    });

    await dbHelper.deleteRound(roundId);
  }

  // Select Round

  int? _roundSelected;
  int? get roundSelected => _roundSelected;

  void selectRoundByIndex(int? index) {
    _roundSelected = index;
    notifyListeners();
  }
}
