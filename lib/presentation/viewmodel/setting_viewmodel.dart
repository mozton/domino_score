import 'package:dominos_score/domain/repositories/setting_resopitory.dart';
import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier {
  SettingViewModel(this._settingRepository) {
    _loadTheme(); // Llamada al método asíncrono al iniciar la clase
  }

  // ======================== // SETTINGS // ======================== //

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  final SettingRepository _settingRepository;

  Future<void> cycleTheme() async {
    switch (_themeMode) {
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
        _settingRepository.saveThemeMode('light');
        break;
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        _settingRepository.saveThemeMode('dark');
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
        _settingRepository.saveThemeMode('system');
        break;
    }
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final themeMode = await _settingRepository.getThemeMode();
    if (themeMode == 'light') {
      _themeMode = ThemeMode.light;
    } else if (themeMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  // FOCUS NODE

  final FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Offset getButtonPosition(GlobalKey key) {
    final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    return box.localToGlobal(Offset.zero);
  }
}
