// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class CreatePostEvent {}

class PickImages extends CreatePostEvent {
  final BuildContext context;
  PickImages({
    required this.context,
  });
}

class CancelImage extends CreatePostEvent {
  final int index;
  CancelImage({
    required this.index,
  });
}

class OnPostCreate extends CreatePostEvent {
  final TextEditingController controller;
  final BuildContext context;
  OnPostCreate({
    required this.controller,
    required this.context,
  });
}
