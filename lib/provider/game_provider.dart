import 'package:dominos_score/model/models.dart';
import 'package:dominos_score/services/database_helper.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  // late GameModel _game;
  String _selectedTeam = '';

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

  GameProvider() {
    initGameOnStartup();

    // final actualRound = currentGame.rounds.last.number;
  }
  // ========================  Initialization  ======================== //

  Future<void> initGameOnStartup() async {
    // 1. Buscar si hay juegos en la BD
    final games = await dbHelper.getGames();

    if (games.isNotEmpty) {
      // Si ya existe un juego, usar el último
      currentGame = games.last;
      print("Juego existente cargado: ID ${currentGame.id}");
      notifyListeners();
      return;
    }

    // 2. Si NO existe ningún juego → crear uno
    print("No hay juegos, creando uno nuevo...");

    final newGame = GameModel(
      actualRound: 0,
      pointsToWin: pointsToWin,
      createdAt: DateTime.now(),
      teams: [],
      rounds: [],
    );

    // 3. Insertar juego en la BD
    final gameId = await dbHelper.createGame(newGame);
    newGame.id = gameId;

    // 4. Insertar equipos por defecto
    final team1 = Team(id: null, gameId: gameId, name: "Team 1");
    final team2 = Team(id: null, gameId: gameId, name: "Team 2");

    final team1Id = await dbHelper.insertTeam(gameId, team1);
    final team2Id = await dbHelper.insertTeam(gameId, team2);

    newGame.teams.add(Team(id: team1Id, gameId: gameId, name: "Team 1"));

    newGame.teams.add(Team(id: team2Id, gameId: gameId, name: "Team 2"));

    currentGame = newGame;

    print("Juego creado automáticamente con ID $gameId");
    // print(currentGame.actualRound);
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

    // Save in provider
    currentGame = newGame;
    // print("Nuevo juego creado con ID: $gameId");

    notifyListeners();
  }

  Future<void> updateScoreToWin() async {
    await dbHelper.updatePointToWin(currentGame.id!, pointsToWin);
    currentGame.pointsToWin = pointsToWin;

    notifyListeners();
  }
  // ============================== // TEAMS // ============================== //

  // Add Teams

  Future<void> addTeam(Team team, int teamId) async {
    final gameId = currentGame.id;

    // 1. Insertar en DB y obtener el ID real
    final teamId = await dbHelper.insertTeam(gameId!, team);

    // 2. Crear un nuevo objeto Team con ese ID
    final newTeam = Team(id: teamId, gameId: gameId, name: team.name);

    currentGame.teams.add(newTeam);
    print("Equipo agregado con ID $teamId al juego $gameId");

    notifyListeners();
  }

  // UpdateTeamsName

  Future<void> updateTeamName(int teamId, String newName) async {
    // 1. Update en la BD
    final result = await dbHelper.updateTeamName(teamId, newName);

    // print(result);
    if (result > 0) {
      // 2. Update en memoria
      final index = currentGame.teams.indexWhere((team) => team.id == teamId);

      if (index != -1) {
        final oldTeam = currentGame.teams[index];

        currentGame.teams[index] = Team(
          id: oldTeam.id,
          gameId: oldTeam.gameId,
          name: newName,
        );

        print("Team actualizado localmente.");
        print("Nuevo nombre: ${currentGame.teams[index].name}");
      }
    }
    notifyListeners();
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

    Round newRound = Round(
      number: actualRound,
      team1Points: pointsTeam1,
      team2Points: pointsTeam2,
    );

    final int newId = await dbHelper.insertRound(currentGame.id!, newRound);

    newRound.id = newId;

    currentGame.rounds.add(newRound);

    await dbHelper.updateActualRound(currentGame.id!, actualRound);
    // await dbHelper.updateTotalScoreTeam(currentGame.id!, totalTeam1Points);

    notifyListeners();
  }

  int get totalTeam1Points {
    return currentGame.rounds.fold(0, (sum, round) => sum + round.team1Points);
  }

  int get totalTeam2Points {
    return currentGame.rounds.fold(0, (sum, round) => sum + round.team2Points);
  }

  // Delete points in round

  Future<void> deleteRound(int roundId) async {
    currentGame.rounds.removeWhere((r) {
      print(r.id);
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

  // TODO: Mover estos Setting al shared preferences

  // ======================== // SETTINGS // ======================== //

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  bool _isSystemTheme = false;
  bool get isSystemTheme => _isSystemTheme;

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    notifyListeners();
  }

  void toggleSystemTheme(bool isOn) {
    _isSystemTheme = isOn;
    notifyListeners();
  }

  // FOCUS NODE

  final FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    pointController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
