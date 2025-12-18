import 'package:dominos_score/data/local/local_setting_data_source.dart';
import 'package:dominos_score/domain/repositories/setting_resopitory.dart';

class SettingRepositoryImpl implements SettingRepository {
  final LocalSettingDataSource _localSettingDataSource =
      LocalSettingDataSource();

  @override
  Future<void> saveThemeMode(String value) async {
    return _localSettingDataSource.saveTheme(value);
  }

  @override
  Future<String?> getThemeMode() async {
    return _localSettingDataSource.getTheme();
  }

  @override
  Future<void> saveUserEmail(String value) async {
    return _localSettingDataSource.saveUserEmail(value);
  }

  @override
  String? getUserEmail() {
    return _localSettingDataSource.getUserEmail();
  }
}
