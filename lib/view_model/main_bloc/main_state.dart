import 'package:flutter/material.dart';

class MainState {
  final int currentIndex;
  final Widget currentBody;
  MainState({
    required this.currentIndex,
    required this.currentBody,
  });

  MainState copyWith({
    int? currentIndex,
    Widget? currentBody,
  }) {
    return MainState(
      currentIndex: currentIndex ?? this.currentIndex,
      currentBody: currentBody ?? this.currentBody,
    );
  }
 }

