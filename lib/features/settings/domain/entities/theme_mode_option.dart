/// Modo de tema soportado por la app.
enum ThemeModeOption { system, light, dark }

extension ThemeModeOptionX on ThemeModeOption {
  String get storageValue => name;

  static ThemeModeOption fromStorage(String? value) {
    switch (value) {
      case 'light':
        return ThemeModeOption.light;
      case 'dark':
        return ThemeModeOption.dark;
      default:
        return ThemeModeOption.system;
    }
  }
}
