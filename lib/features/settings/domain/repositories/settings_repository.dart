import 'package:dominos_score/features/settings/domain/entities/theme_mode_option.dart';

/// Contrato del repositorio de ajustes de la aplicación.
abstract class SettingsRepository {
  Future<ThemeModeOption?> getThemeMode();
  Future<void> saveThemeMode(ThemeModeOption value);

  Future<int?> getPointToWin();
  Future<void> savePointToWin(int value);

  /// Nombre del modo de partida (GameMode.name): equipos 2v2 o individual.
  Future<String?> getGameModeName();
  Future<void> saveGameModeName(String value);
}
