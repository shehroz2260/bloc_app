// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

abstract class BioEvent {}

class OnContinue extends BioEvent {
  final TextEditingController bioController;
  final TextEditingController aboutController;
  final BuildContext context;
  OnContinue({
    required this.bioController,
    required this.aboutController,
    required this.context,
  });
}
