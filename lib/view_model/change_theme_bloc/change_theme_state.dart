import 'package:flutter/material.dart';

class ChangeThemeState {
  final ThemeData currentTheme;
  ChangeThemeState({
    required this.currentTheme,
  });

  ChangeThemeState copyWith({
    ThemeData? currentTheme,
  }) {
    return ChangeThemeState(
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }
}
