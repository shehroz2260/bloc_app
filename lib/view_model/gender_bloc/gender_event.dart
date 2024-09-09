// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
abstract class GenderEvent {}

class PickGender extends GenderEvent {
  final int gender;
  PickGender({
    required this.gender,
  });
}

class OnNextEvent extends GenderEvent {
  final BuildContext context;
  OnNextEvent({
    required this.context,
  });
}
