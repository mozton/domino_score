import 'package:dominos_score/features/settings/domain/entities/theme_mode_option.dart';

/// Contrato del origen de datos local (SharedPreferences) de ajustes.
abstract class SettingsLocalDataSource {
  ThemeModeOption? getThemeMode();
  Future<void> saveThemeMode(ThemeModeOption value);

  int? getPointToWin();
  Future<void> savePointToWin(int value);

  String? getGameModeName();
  Future<void> saveGameModeName(String value);
}
