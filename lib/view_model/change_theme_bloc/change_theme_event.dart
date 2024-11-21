// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class ChangeThemeEvent {}

class ChangeThemeMode extends ChangeThemeEvent {
  final ThemeData theme;
  ChangeThemeMode({
    required this.theme,
  });
}

class OninitTheme extends ChangeThemeEvent {}
