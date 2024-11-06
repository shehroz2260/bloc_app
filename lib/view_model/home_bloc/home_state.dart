// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_with_bloc/model/user_model.dart';

class HomeState {
  final List<UserModel> userList;
  final bool isLoading;
  HomeState({
    required this.userList,
    required this.isLoading,
  });

  HomeState copyWith({
    List<UserModel>? userList,
    bool? isLoading,
  }) {
    return HomeState(
      userList: userList ?? this.userList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
