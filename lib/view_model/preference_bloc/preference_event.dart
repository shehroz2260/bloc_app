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
  final bool isUpdate;
  OnNextEvent({
    required this.context,
    required this.isUpdate,
  });
}

class SelectInstrest extends PreferenceEvent {
  final int index;
  SelectInstrest({
    required this.index,
  });
}

class OnInitEdit extends PreferenceEvent {
  final BuildContext context;
  OnInitEdit({
    required this.context,
  });
}
