import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../services/local_storage_service.dart';
import 'change_language_event.dart';
import 'change_language_state.dart';

class ChangeLanguageBloc
    extends Bloc<ChangeLanguageEvent, ChangeLanguageState> {
  ChangeLanguageBloc()
      : super(ChangeLanguageState(locale: const Locale("en"))) {
    on<ChnageLocale>(_changeLocale);
    on<OnitLanguage>(_onit);
  }

  _changeLocale(ChnageLocale event, Emitter<ChangeLanguageState> emit) async {
    Locale newLocale = Locale(event.code);
    emit(state.copyWith(locale: newLocale));
    LocalStorageService.storage
        .write(LocalStorageService.languageKey, event.code);
  }

  _onit(OnitLanguage event, Emitter<ChangeLanguageState> emit) async {
    String? savedLocale =
        LocalStorageService.storage.read(LocalStorageService.languageKey) ?? "";
    if (savedLocale.isNotEmpty) {
      emit(state.copyWith(locale: Locale(savedLocale)));
    }
  }
}
