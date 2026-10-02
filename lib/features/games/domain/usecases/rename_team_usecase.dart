import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Renombra un equipo.
class RenameTeamUseCase {
  final GameRepository repository;

  RenameTeamUseCase(this.repository);

  Future<void> call(int teamId, String newName) =>
      repository.updateTeamName(teamId, newName);
}
