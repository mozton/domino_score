import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingDataSource {
  static final LocalSettingDataSource _instance =
      LocalSettingDataSource._internal();
  static SharedPreferences? _prefs;

  factory LocalSettingDataSource() {
    return _instance;
  }

  LocalSettingDataSource._internal();

  /// Inicializar en main()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get instance interna
  static SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception(
        "SharedPreferences no inicializado. Llama Prefs.init() en main()",
      );
    }
    return _prefs!;
  }

  // ===================== Theme Mode ===================== //

  Future<void> saveTheme(String value) async {
    await instance.setString('theme_mode', value);
  }

  String? getTheme() {
    return instance.getString('theme_mode');
  }

  //==================== User Data ===================== //

  Future<void> saveUserEmail(String value) async {
    await instance.setString('user_email', value);
  }

  String? getUserEmail() {
    return instance.getString('user_email');
  }

  //==================== Data Game ===================== //

  Future<void> savePointToWin(int value) async {
    await instance.setInt('point_to_win', value);
  }

  int? getPointToWin() {
    return instance.getInt('point_to_win');
  }

  // ===================== Example ===================== //

  Future<void> setString(String key, String value) async {
    await instance.setString(key, value);
  }

  String? getString(String key) {
    return instance.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await instance.setBool(key, value);
  }

  bool? getBool(String key) {
    return instance.getBool(key);
  }
}
