// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

abstract class FilterEvent {}

class ONChangedAges extends FilterEvent {
  final SfRangeValues onChanged;
  ONChangedAges({
    required this.onChanged,
  });
}

class ONInitEvent extends FilterEvent {}

class OnChangedGender extends FilterEvent {
  final int gender;
  OnChangedGender({
    required this.gender,
  });
}

class OnAppLyFilter extends FilterEvent {
  final BuildContext context;
  OnAppLyFilter({
    required this.context,
  });
}
