import 'package:flutter/material.dart';

class ChangeThemeState {
  final ThemeMode currentTheme;
  ChangeThemeState({
    required this.currentTheme,
  });

  ChangeThemeState copyWith({
    ThemeMode? currentTheme,
  }) {
    return ChangeThemeState(
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }
}
