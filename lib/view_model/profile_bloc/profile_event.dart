// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class ProfileEvent {}

class OninitProfileFunction extends ProfileEvent {
  final BuildContext context;
  OninitProfileFunction({
    required this.context,
  });
}
