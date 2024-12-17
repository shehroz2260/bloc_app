// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class LocationEvent {}

class OnRequestPermissionEvent extends LocationEvent {
  final BuildContext context;
  final bool isFromOnboard;
  OnRequestPermissionEvent({
    required this.context,
    required this.isFromOnboard,
  });
}

class OnPublically extends LocationEvent {
  final bool isOn;
  final BuildContext context;
  OnPublically({
    required this.isOn,
    required this.context,
  });
}
