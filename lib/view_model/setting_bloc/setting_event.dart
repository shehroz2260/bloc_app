// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class SettingEvent {}

class OnNotificationEvent extends SettingEvent {
  final bool isOn;
  final BuildContext context;
  OnNotificationEvent({
    required this.isOn,
    required this.context,
  });
}

class OninitSetting extends SettingEvent {
  final BuildContext context;
  OninitSetting({
    required this.context,
  });
}
