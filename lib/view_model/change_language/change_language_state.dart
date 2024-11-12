// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ChangeLanguageState {
  final Locale locale;
  ChangeLanguageState({
    required this.locale,
  });

  ChangeLanguageState copyWith({
    Locale? locale,
  }) {
    return ChangeLanguageState(
      locale: locale ?? this.locale,
    );
  }
}
