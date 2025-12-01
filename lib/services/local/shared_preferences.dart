import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final Prefs _instance = Prefs._internal();
  static SharedPreferences? _prefs;

  factory Prefs() {
    return _instance;
  }

  Prefs._internal();

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

  // -----------------------------
  // Métodos de ejemplo
  // -----------------------------

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
