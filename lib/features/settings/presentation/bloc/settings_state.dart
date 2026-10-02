part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final ThemeModeOption themeMode;

  const SettingsState({this.themeMode = ThemeModeOption.system});

  SettingsState copyWith({ThemeModeOption? themeMode}) {
    return SettingsState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object?> get props => [themeMode];
}
