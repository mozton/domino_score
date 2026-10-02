import 'package:dominos_score/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:dominos_score/features/settings/domain/entities/theme_mode_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementación con SharedPreferences del origen de datos de ajustes.
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const _themeKey = 'theme_mode';
  static const _pointToWinKey = 'point_to_win';
  static const _gameModeKey = 'game_mode';

  final SharedPreferences _prefs;

  SettingsLocalDataSourceImpl(this._prefs);

  @override
  ThemeModeOption? getThemeMode() {
    final value = _prefs.getString(_themeKey);
    if (value == null) return null;
    return ThemeModeOptionX.fromStorage(value);
  }

  @override
  Future<void> saveThemeMode(ThemeModeOption value) async {
    await _prefs.setString(_themeKey, value.storageValue);
  }

  @override
  int? getPointToWin() => _prefs.getInt(_pointToWinKey);

  @override
  Future<void> savePointToWin(int value) async {
    await _prefs.setInt(_pointToWinKey, value);
  }

  @override
  String? getGameModeName() => _prefs.getString(_gameModeKey);

  @override
  Future<void> saveGameModeName(String value) async {
    await _prefs.setString(_gameModeKey, value);
  }
}
