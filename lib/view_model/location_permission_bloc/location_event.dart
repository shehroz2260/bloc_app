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
