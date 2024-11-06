// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class EditEvent {}

class ImagesPick extends EditEvent {
  final BuildContext context;
  ImagesPick({
    required this.context,
  });
}

class OndisPose extends EditEvent {}

class OpenEditTextField extends EditEvent {}

class UpdateUser extends EditEvent {
  final BuildContext context;
  final String firstName;
  final String bio;
  final String about;
  UpdateUser({
    required this.context,
    required this.firstName,
    required this.bio,
    required this.about,
  });
}

class OnPickDateTime extends EditEvent {
  final BuildContext context;
  OnPickDateTime({
    required this.context,
  });
}
