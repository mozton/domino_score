part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

/// Inicializa el juego al arrancar la app.
///
/// [groupId] indica el grupo cuyo historial se juega; `null` = partidas
/// locales (historial general del usuario).
class GameInitialized extends GameEvent {
  final String? groupId;
  final String? groupName;

  const GameInitialized({this.groupId, this.groupName});

  @override
  List<Object?> get props => [groupId, groupName];
}

/// Inicia una partida nueva dentro de un grupo (se guarda en Firestore bajo el
/// grupo y la ven todos sus miembros).
class GroupGameStarted extends GameEvent {
  final String groupId;
  final String? groupName;
  final GameMode mode;

  const GroupGameStarted({
    required this.groupId,
    this.groupName,
    required this.mode,
  });

  @override
  List<Object?> get props => [groupId, groupName, mode];
}

/// Carga todas las partidas (historial).
class GamesLoaded extends GameEvent {
  const GamesLoaded();
}

/// Inicia una partida nueva con los equipos por defecto del [mode].
class NewGameStarted extends GameEvent {
  final GameMode mode;

  const NewGameStarted(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Inicia una partida nueva reutilizando los equipos actuales.
class NewGameWithTeamsStarted extends GameEvent {
  const NewGameWithTeamsStarted();
}

/// Añade una ronda con los puntos de cada equipo (en orden) y las acciones de
/// la metodología (capicúa, pase redondo, trancao, zapatero, pase individual).
class RoundAdded extends GameEvent {
  final List<int> teamPoints;
  final List<RoundEvent> events;

  const RoundAdded({required this.teamPoints, this.events = const []});

  @override
  List<Object?> get props => [teamPoints, events];
}

/// Marca (o limpia con `null`) el equipo en el que juega el usuario.
class MyTeamSelected extends GameEvent {
  final int? teamIndex;

  const MyTeamSelected(this.teamIndex);

  @override
  List<Object?> get props => [teamIndex];
}

/// Selecciona (o deselecciona) una ronda por índice.
class RoundSelected extends GameEvent {
  final int? index;

  const RoundSelected(this.index);

  @override
  List<Object?> get props => [index];
}

/// Elimina la ronda actualmente seleccionada.
class SelectedRoundDeleted extends GameEvent {
  const SelectedRoundDeleted();
}

/// Renombra un equipo.
class TeamRenamed extends GameEvent {
  final int teamId;
  final String newName;

  const TeamRenamed({required this.teamId, required this.newName});

  @override
  List<Object?> get props => [teamId, newName];
}

/// Cambia el modo de partida (equipos 2v2 / individual 2-3-4) y reinicia el
/// marcador con la nueva cantidad de equipos.
class GameModeSelected extends GameEvent {
  final GameMode mode;

  const GameModeSelected(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Selecciona un valor de "puntos para ganar".
class PointsToWinSelected extends GameEvent {
  final int points;

  const PointsToWinSelected(this.points);

  @override
  List<Object?> get props => [points];
}

/// Aplica el valor de "puntos para ganar" a la partida actual.
class PointsToWinChanged extends GameEvent {
  const PointsToWinChanged();
}

/// Limpia el estado de ganador.
class WinnerReset extends GameEvent {
  const WinnerReset();
}
