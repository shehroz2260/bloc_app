import 'package:flutter/material.dart';

abstract class GalleryEvent {}

class SelectImage extends GalleryEvent {
  final BuildContext context;
  SelectImage({
    required this.context,
  });
}

class ClearImage extends GalleryEvent {
  final int index;
  final BuildContext context;
  ClearImage({
    required this.index,
    required this.context,
  });
}
