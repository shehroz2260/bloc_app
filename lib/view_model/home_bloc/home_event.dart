// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';

import '../../model/user_model.dart';

abstract class HomeEvent {}

class ONINITEvent extends HomeEvent {
  final BuildContext context;
  final UserBaseBloc? userBaseBloc;
  ONINITEvent({required this.context, this.userBaseBloc});
}

class RemoveUserFromList extends HomeEvent {
  final UserModel userModel;
  RemoveUserFromList({
    required this.userModel,
  });
}

class LikeUser extends HomeEvent {
  final UserModel liker;
  final UserModel likee;
  final BuildContext context;
  LikeUser({
    required this.likee,
    required this.context,
    required this.liker,
  });
}

class DisLikeUser extends HomeEvent {
  final UserModel liker;
  final UserModel likee;
  final BuildContext context;
  DisLikeUser({
    required this.liker,
    required this.likee,
    required this.context,
  });
}

class OnReportUser extends HomeEvent {
  final BuildContext context;
  final UserModel userModel;
  OnReportUser({
    required this.context,
    required this.userModel,
  });
}
