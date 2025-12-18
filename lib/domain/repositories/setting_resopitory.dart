abstract class SettingRepository {
  // Theme Mode
  Future<void> saveThemeMode(String value);
  Future<String?> getThemeMode();

  // User Data
  Future<void> saveUserEmail(String value);
  String? getUserEmail();
}
