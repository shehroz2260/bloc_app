// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../model/user_model.dart';

abstract class HomeEvent {}

class ONINITEvent extends HomeEvent {
  
}

class RemoveUserFromList extends HomeEvent {
  final UserModel userModel;
  RemoveUserFromList({
    required this.userModel,
  });
}