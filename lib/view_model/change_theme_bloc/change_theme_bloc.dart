import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/services/local_storage_service.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:flutter/material.dart';
import 'change_theme_event.dart';
import 'change_theme_state.dart';

class ChangeThemeBloc extends Bloc<ChangeThemeEvent, ChangeThemeState> {
  ChangeThemeBloc() : super(ChangeThemeState(currentTheme: ThemeData.light())) {
    on<ChangeThemeMode>(_onChangeTheme);
    on<OninitTheme>(_oinitTheme);
  }

  _onChangeTheme(ChangeThemeMode event, Emitter<ChangeThemeState> emit) {
    emit(state.copyWith(currentTheme: event.theme));
    AppTheme()
        .oninFunc(event.theme.brightness == Brightness.dark ? true : false);
    LocalStorageService.storage.write(LocalStorageService.themeKey,
        event.theme.brightness == Brightness.dark ? true : false);
  }

  _oinitTheme(OninitTheme event, Emitter<ChangeThemeState> emit) {
    final isDark =
        LocalStorageService.storage.read(LocalStorageService.themeKey) ?? false;

    emit(state.copyWith(
        currentTheme: isDark ? ThemeData.dark() : ThemeData.light()));
  }
}
