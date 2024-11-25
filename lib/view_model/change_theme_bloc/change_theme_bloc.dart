import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:flutter/material.dart';
import '../../services/local_storage_service.dart';
import 'change_theme_event.dart';
import 'change_theme_state.dart';

class ChangeThemeBloc extends Bloc<ChangeThemeEvent, ChangeThemeState> {
  ChangeThemeBloc() : super(ChangeThemeState(currentTheme: ThemeMode.light)) {
    on<ChangeThemeMode>(_onChangeTheme);
    on<OninitTheme>(_oinitTheme);
  }

  _onChangeTheme(ChangeThemeMode event, Emitter<ChangeThemeState> emit) {
    emit(state.copyWith(currentTheme: event.theme));
    AppTheme.saveThemeMode(event.theme);
  }

  _oinitTheme(OninitTheme event, Emitter<ChangeThemeState> emit) {
    final isDark = LocalStorageService.storage.read(kThemeModeKey) ?? false;

    emit(state.copyWith(
        currentTheme: isDark ? ThemeMode.dark : ThemeMode.light));
  }
}
