import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier {
  // ======================== // SETTINGS // ======================== //

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  bool _isSystemTheme = false;
  bool get isSystemTheme => _isSystemTheme;

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    notifyListeners();
  }

  void toggleSystemTheme(bool isOn) {
    _isSystemTheme = isOn;
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
