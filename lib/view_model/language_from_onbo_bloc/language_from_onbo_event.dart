import 'package:flutter/material.dart';

abstract class LanguageFromOnboEvent {}

class UdateLanguage extends LanguageFromOnboEvent {
  final int index;
  final String code;
  final BuildContext context;
  UdateLanguage({
    required this.code,
    required this.index,
    required this.context,
  });
}
