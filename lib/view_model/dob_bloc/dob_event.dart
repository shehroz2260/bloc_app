// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class DobEvent {}

class DatePickerEvent extends DobEvent {
  final BuildContext context;
  DatePickerEvent({
    required this.context,
  });
}

class ImagePickerEvent extends DobEvent {
  final BuildContext context;
  ImagePickerEvent({required this.context});
}

class OnNextEvent extends DobEvent {
  final TextEditingController nameController;
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  OnNextEvent({
    required this.context,
    required this.nameController,
    required this.formKey,
  });
}

class ClearAllValue extends DobEvent {}
