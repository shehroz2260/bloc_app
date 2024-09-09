// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_with_bloc/model/user_model.dart';

class HomeState {
  final List<UserModel> userList;
  HomeState({
    required this.userList,
  });

  HomeState copyWith({
    List<UserModel>? userList,
  }) {
    return HomeState(
      userList: userList ?? this.userList,
    );
  }
 }
