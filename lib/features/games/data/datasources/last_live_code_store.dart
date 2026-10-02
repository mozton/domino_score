import 'package:shared_preferences/shared_preferences.dart';

/// Recuerda el último código de partida en vivo que se abrió.
///
/// Sirve para poder **volver** a esa partida sin tener que escribir el código
/// otra vez (los invitados no son miembros del grupo, así que no la ven en
/// ninguna lista).
abstract class LastLiveCodeStore {
  Future<String?> read();
  Future<void> save(String code);
  Future<void> clear();
}

/// Implementación con `SharedPreferences`.
class PreferencesLastLiveCodeStore implements LastLiveCodeStore {
  static const String _key = 'live_last_code';

  final SharedPreferences _preferences;

  PreferencesLastLiveCodeStore(this._preferences);

  @override
  Future<String?> read() async => _preferences.getString(_key);

  @override
  Future<void> save(String code) async => _preferences.setString(_key, code);

  @override
  Future<void> clear() async => _preferences.remove(_key);
}

/// Implementación vacía: la usa el BLoC por defecto para no depender de la
/// plataforma (por ejemplo, en las pruebas).
class NoLastLiveCodeStore implements LastLiveCodeStore {
  const NoLastLiveCodeStore();

  @override
  Future<String?> read() async => null;

  @override
  Future<void> save(String code) async {}

  @override
  Future<void> clear() async {}
}
