import 'package:dominos_score/features/settings/domain/entities/theme_mode_option.dart';
import 'package:dominos_score/features/settings/domain/repositories/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// BLoC de ajustes (tema claro/oscuro/sistema).
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc(this._repository) : super(const SettingsState()) {
    on<SettingsLoadRequested>(_onLoad);
    on<SettingsThemeCycled>(_onCycleTheme);
  }

  Future<void> _onLoad(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final mode = await _repository.getThemeMode();
    emit(state.copyWith(themeMode: mode ?? ThemeModeOption.system));
  }

  Future<void> _onCycleTheme(
    SettingsThemeCycled event,
    Emitter<SettingsState> emit,
  ) async {
    final next = switch (state.themeMode) {
      ThemeModeOption.system => ThemeModeOption.light,
      ThemeModeOption.light => ThemeModeOption.dark,
      ThemeModeOption.dark => ThemeModeOption.system,
    };
    await _repository.saveThemeMode(next);
    emit(state.copyWith(themeMode: next));
  }
}
