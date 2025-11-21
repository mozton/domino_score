import 'package:dominos_score/model/models.dart';
import 'package:dominos_score/services/database_helper.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  // late GameModel _game;
  String _selectedTeam = '';

  int pointsToWin = 200;
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
  }

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
      pointsToWin: 200,
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
    notifyListeners();
  }

  // Future<void> loadGameOnStar() async {
  //   allGames = await dbHelper.getGames();

  //   if (allGames.isNotEmpty) {
  //     currentGame = allGames.last;
  //     print('Ultimo juego cargado: ${currentGame.id}');
  //   } else {
  //     print('No hay juegos');
  //   }
  //   notifyListeners();
  // }

  void updateName() {
    notifyListeners();
  }

  Future<void> createGame() async {
    // 1. Crear el objeto del juego sin ID
    final newGame = GameModel(
      actualRound: 0,
      pointsToWin: seletPointToWin,
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
    print("Nuevo juego creado con ID: $gameId");

    notifyListeners();
  }

  Future<void> updateScoreToWin() async {
    await dbHelper.updatePointToWin(currentGame.id!, pointsToWin);
    currentGame.pointsToWin = pointsToWin;

    print('Game con ID ${currentGame.id} Puntos insertados: $pointsToWin');
    print(currentGame.pointsToWin);

    notifyListeners();
  }
  // ============================== // TEAMS // ============================== //

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

  // UpdateName

  Future<void> updateTeamName(int teamId, String newName) async {
    // 1. Update en la BD
    final result = await dbHelper.updateTeamName(teamId, newName);

    print(result);
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

  // final DatabaseHelper _databaseHelper = DatabaseHelper();

  // GameProvider() {
  //   _databaseHelper.getGames();
  // _game = GameModel(
  //     rounds: [],
  //     actualRound: 1,
  //     team1: (Team(id: 1, name: 'TEAM 1')),
  //     team2: (Team(id: 2, name: 'TEAM 2')),
  //     pointsToWin: pointsToWin,
  //   );
  //   // _databaseHelper.createGame(_game);

  //   isStartEnable;
  // }

  // Getters
  String get selectedTeam => _selectedTeam;
  // String get team1Name => _game.team1.name;
  // String get team2Name => _game.team2.name;
  // int get actualRound => _game.actualRound;

  // List<Round> get rounds => _game.rounds;
  // Controllers

  final TextEditingController _pointController = TextEditingController();
  TextEditingController get pointController => _pointController;

  final TextEditingController _team1NameController = TextEditingController();
  TextEditingController get team1NameController => _team1NameController;

  final TextEditingController _team2NameController = TextEditingController();
  TextEditingController get team2NameController => _team2NameController;

  // Setters for change name of teams

  // set team1Name(String name) => _game.team1.name = name;

  // set team2Name(String name) => _game.team2.name = name;

  // Puntos totales
  final List<int> _pointsToWinList = [100, 200, 300];
  List<int> get pointsToWins => _pointsToWinList;

  // int get team1Total {
  //   int total = 0;
  //   for (var round in _game.rounds) {
  //     total += round.pointTeam1;

  //     // Verificar si alcanzó 200 puntos
  //     if (total >= pointsToWin) {
  //       // _declararGanador(team1Name);
  //       break; // Opcional
  //     }
  //   }
  //   return total;
  // }

  // int get team2Total {
  //   int total = 0;
  //   for (var round in _game.rounds) {
  //     total += round.pointTeam2;

  //     if (total >= pointsToWin) {
  //       // _declararGanador(team2Name);
  //       break; // Opcional
  //     }
  //   }
  //   return total;
  // }

  // Método para manejar cuando un equipo gana
  // _declararGanador(String teamName) {}

  // Métodos

  void clearSelection() {
    _selectedTeam = '';
    notifyListeners();
  }

  // void addRound(String team, int points) async {
  //   final newRound = Round(
  //     round: _game.actualRound,
  //     pointTeam1: 0,
  //     pointTeam2: 0,
  //   );

  //   if (team == team1Name) {
  //     newRound.pointTeam1 = points;
  //   } else if (team == team2Name) {
  //     newRound.pointTeam2 = points;
  //   }

  //   _game.rounds.add(newRound);
  //   _game.actualRound++;

  //   notifyListeners();
  // }

  void deletePoint(int index) {
    // rounds.removeAt(index);
    notifyListeners();
  }

  // void createNewGame() {
  //   _game = GameModel(
  //     rounds: [],
  //     actualRound: 1,
  //     team1: _game.team1,
  //     team2: _game.team2,
  //     pointsToWin: pointsToWin,
  //   );
  //   _selectedTeam = '';

  //   notifyListeners();
  // }

  // void createGameNewTeam() {
  //   _game = GameModel(
  //     rounds: [],
  //     actualRound: 1,
  //     team1: (Team(id: 1, name: 'TEAM 1')),
  //     team2: (Team(id: 2, name: 'TEAM 2')),
  //     pointsToWin: pointsToWin,
  //   );
  //   _pointSelect = -2;
  //   //TODO: Cuando otro equipo inicie partida los puntos ya se quedaran predeterminados
  //   //en el valor seleccionado inicialmente, se establecera la primera vez y luego se hara desde settings

  //   notifyListeners();
  // }

  void pointTotal(int points) {}

  // Theme Mode
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

  // ======================== Select Round ======================== //

  int? _roundSelected;
  int? get roundSelected => _roundSelected;

  void selectRoundByIndex(int? index) {
    _roundSelected = index;
    notifyListeners();
  }

  // ========================  Point Select to Win ======================== //

  int? _pointSelect = -2;
  int? get pointToWinIsSelected => _pointSelect;

  void selectPointToWin(int isSelected) {
    _pointSelect = isSelected;
    notifyListeners();
  }

  // ======================== Events ======================== //

  // bool get isStartEnable {
  //   return team1Name != 'TEAM 1' && team2Name != 'TEAM 2';
  // }

  // void setNameTeam1() {
  //   team1Name = team1NameController.text.trim();

  //   notifyListeners();
  // }

  // void setNameTeam2() {
  //   team2Name = _team2NameController.text.trim();
  //   notifyListeners();
  // }

  // void reset() {
  //   team1Name;
  //   team1Name;
  //   notifyListeners();
  // }

  // bool get canStartGame {
  //   return team1Name != 'TEAM 1' && team2Name != 'TEAM 2' && pointsToWin != 0;
  // }
}
