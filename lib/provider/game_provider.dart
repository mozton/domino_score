import 'package:dominos_score/model/game_model.dart';
import 'package:dominos_score/model/round_model.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  late GameModel _game;
  String _selectedTeam = '';
  int pointsToWin = 200;

  GameProvider() {
    _game = GameModel(
      rounds: [],
      actualRound: 1,
      team1: (Team(id: 1, name: 'TEAM 1')),
      team2: (Team(id: 2, name: 'TEAM 2')),
    );
  }

  // Getters
  String get selectedTeam => _selectedTeam;
  String get team1Name => _game.team1.name;
  String get team2Name => _game.team2.name;
  int get actualRound => _game.actualRound;
  int get pointToWin => pointsToWin;

  List<Round> get rounds => _game.rounds;
  final TextEditingController _pointController = TextEditingController();
  TextEditingController get pointController => _pointController;

  // Setters for change name of teams

  set team1Name(String name) => _game.team1.name = name;

  set team2Name(String name) => _game.team2.name = name;

  // Puntos totales
  final List<int> _pointsToWin = [100, 200, 300, 400, 500];
  List<int> get pointsToWins => _pointsToWin;

  int get team1Total {
    int total = 0;
    for (var round in _game.rounds) {
      total += round.pointTeam1;

      // Verificar si alcanzó 200 puntos
      if (total >= pointToWin) {
        _declararGanador(team1Name);
        break; // Opcional
      }
    }
    return total;
  }

  int get team2Total {
    int total = 0;
    for (var round in _game.rounds) {
      total += round.pointTeam2;

      if (total >= pointToWin) {
        _declararGanador(team2Name);
        break; // Opcional
      }
    }
    return total;
  }

  // Método para manejar cuando un equipo gana
  _declararGanador(String teamName) {}

  // Métodos

  // void selectTeam(String teamName) {
  //   _selectedTeam = teamName;
  //   // print('Equipo seleccionado: $_selectedTeam'); // Debug
  //   notifyListeners();
  // }

  void clearSelection() {
    _selectedTeam = '';
    notifyListeners();
  }

  void addRound(String team, int points) {
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

  void deletePoint(int index) {
    rounds.removeAt(index);
    notifyListeners();
  }

  void resetGame() {
    _game = GameModel(
      rounds: [],
      actualRound: 1,
      team1: _game.team1,
      team2: _game.team2,
    );
    _selectedTeam = '';
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
}
