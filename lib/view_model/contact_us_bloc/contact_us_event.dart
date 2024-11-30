import 'package:flutter/material.dart';

abstract class ContactUsEvent {}

class OninintContactus extends ContactUsEvent {
  final BuildContext context;
  OninintContactus({
    required this.context,
  });
}

class OnDisposeContact extends ContactUsEvent {}
