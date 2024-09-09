import 'package:flutter/material.dart';

abstract class LocationEvent {}


class OnRequestPermissionEvent extends LocationEvent {
  final BuildContext context;
  OnRequestPermissionEvent({
    required this.context,
  });
}
