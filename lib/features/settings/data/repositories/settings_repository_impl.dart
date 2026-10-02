import 'package:dominos_score/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:dominos_score/features/settings/domain/entities/theme_mode_option.dart';
import 'package:dominos_score/features/settings/domain/repositories/settings_repository.dart';

/// Implementación del repositorio de ajustes.
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  Future<ThemeModeOption?> getThemeMode() async => _dataSource.getThemeMode();

  @override
  Future<void> saveThemeMode(ThemeModeOption value) =>
      _dataSource.saveThemeMode(value);

  @override
  Future<int?> getPointToWin() async => _dataSource.getPointToWin();

  @override
  Future<void> savePointToWin(int value) => _dataSource.savePointToWin(value);

  @override
  Future<String?> getGameModeName() async => _dataSource.getGameModeName();

  @override
  Future<void> saveGameModeName(String value) =>
      _dataSource.saveGameModeName(value);
}
