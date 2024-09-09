// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
abstract class DobEvent {}


class DatePickerEvent extends DobEvent {
 final TextEditingController textEditingController;
 final BuildContext context;
  DatePickerEvent({
    required this.textEditingController,
    required this.context,
  });
}

class OnNextEvent extends DobEvent {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  OnNextEvent({
    required this.context,
    required this.formKey,
  });
}
