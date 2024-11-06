// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';

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
  final UserBaseBloc userBloc;
  final BuildContext context;
  OnAppLyFilter({
    required this.context,
    required this.userBloc,
  });
}

class OnChangeRadisus extends FilterEvent {
  final double value;
  final BuildContext context;
  OnChangeRadisus({
    required this.value,
    required this.context,
  });
}
