import 'package:dominos_score/services/database_helper.dart';
import 'package:flutter/material.dart';

import 'package:dominos_score/model/models.dart';

class GameProvider extends ChangeNotifier {
  late GameModel _game;
  String _selectedTeam = '';
  int pointsToWin = 0;
  late List<GameModel> _games;
  List<GameModel> get games => _games;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  GameProvider() {
    _databaseHelper.getGames();

    _game = GameModel(
      rounds: [],
      actualRound: 1,
      team1: (Team(id: 1, name: 'TEAM 1')),
      team2: (Team(id: 2, name: 'TEAM 2')),
      pointsToWin: pointsToWin,
    );

    isStartEnable;
  }

  // Getters
  String get selectedTeam => _selectedTeam;
  String get team1Name => _game.team1.name;
  String get team2Name => _game.team2.name;
  int get actualRound => _game.actualRound;
  int get pointToWin => pointsToWin;

  List<Round> get rounds => _game.rounds;
  // Controllers

  final TextEditingController _pointController = TextEditingController();
  TextEditingController get pointController => _pointController;

  final TextEditingController _team1NameController = TextEditingController();
  TextEditingController get team1NameController => _team1NameController;

  final TextEditingController _team2NameController = TextEditingController();
  TextEditingController get team2NameController => _team2NameController;

  // Setters for change name of teams

  set team1Name(String name) => _game.team1.name = name;

  set team2Name(String name) => _game.team2.name = name;

  // Puntos totales
  final List<int> _pointsToWin = [100, 200, 300];
  List<int> get pointsToWins => _pointsToWin;

  int get team1Total {
    int total = 0;
    for (var round in _game.rounds) {
      total += round.pointTeam1;

      // Verificar si alcanzó 200 puntos
      if (total >= pointsToWin) {
        // _declararGanador(team1Name);
        break; // Opcional
      }
    }
    return total;
  }

  int get team2Total {
    int total = 0;
    for (var round in _game.rounds) {
      total += round.pointTeam2;

      if (total >= pointsToWin) {
        // _declararGanador(team2Name);
        break; // Opcional
      }
    }
    return total;
  }

  // Método para manejar cuando un equipo gana
  // _declararGanador(String teamName) {}

  // Métodos

  void clearSelection() {
    _selectedTeam = '';
    notifyListeners();
  }

  void addRound(String team, int points) async {
    final newRound = Round(
      round: _game.actualRound,
      pointTeam1: 0,
      pointTeam2: 0,
    );

    if (team == team1Name) {
      newRound.pointTeam1 = points;
    } else if (team == team2Name) {
      newRound.pointTeam2 = points;
    }

    _game.rounds.add(newRound);
    _game.actualRound++;

    notifyListeners();
  }

  Future<void> loadRoundsFromDb() async {
    _game.rounds.clear(); // Limpiar rondas actuales
    _game.rounds.addAll(rounds); // Agregar rondas desde BD

    // Actualizar la ronda actual basado en las rondas cargadas
    if (rounds.isNotEmpty) {
      _game.actualRound = rounds.last.round + 1;
    } else {
      _game.actualRound = 1;
    }

    notifyListeners();
  }

  void deletePoint(int index) {
    rounds.removeAt(index);
    notifyListeners();
  }

  void createNewGame() {
    _game = GameModel(
      rounds: [],
      actualRound: 1,
      team1: _game.team1,
      team2: _game.team2,
      pointsToWin: pointsToWin,
    );
    _selectedTeam = '';

    notifyListeners();
  }

  void createGameNewTeam() {
    _game = GameModel(
      rounds: [],
      actualRound: 1,
      team1: (Team(id: 1, name: 'TEAM 1')),
      team2: (Team(id: 2, name: 'TEAM 2')),
      pointsToWin: pointsToWin,
    );
    _pointSelect = -2;
    //TODO: Cuando otro equipo inicie partida los puntos ya se quedaran predeterminados
    //en el valor seleccionado inicialmente, se establecera la primera vez y luego se hara desde settings

    notifyListeners();
  }

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

  bool get isStartEnable {
    return team1Name != 'TEAM 1' && team2Name != 'TEAM 2';
  }

  void setNameTeam1() {
    team1Name = team1NameController.text.trim();

    notifyListeners();
  }

  void setNameTeam2() {
    team2Name = _team2NameController.text.trim();
    notifyListeners();
  }

  void reset() {
    team1Name;
    team1Name;
    notifyListeners();
  }

  bool get canStartGame {
    return team1Name != 'TEAM 1' && team2Name != 'TEAM 2' && pointsToWin != 0;
  }
}
