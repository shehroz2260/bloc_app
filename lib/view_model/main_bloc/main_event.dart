// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class MainEvent {}

class ChangeIndexEvent extends MainEvent {
final int index;
  ChangeIndexEvent({
    required this.index,
  });
}

class ListernerChanges extends MainEvent {
  final BuildContext context;
  ListernerChanges({
    required this.context,
  });
}

class OnDispose extends MainEvent {
  
}