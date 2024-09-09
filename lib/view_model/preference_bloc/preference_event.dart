// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

abstract class PreferenceEvent {}

class PickGenders extends PreferenceEvent {
  final int gender;
  PickGenders({
    required this.gender,
  });
}

class OnNextEvent extends PreferenceEvent {
  final BuildContext context;
  OnNextEvent({
    required this.context,
  });
}
