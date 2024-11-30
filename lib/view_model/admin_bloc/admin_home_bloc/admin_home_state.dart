import 'package:chat_with_bloc/model/user_model.dart';

class AdminHomeState {
  final List<UserModel> userList;
  final String searchText;
  AdminHomeState({
    required this.userList,
    required this.searchText,
  });

  AdminHomeState copyWith({
    List<UserModel>? userList,
    String? searchText,
  }) {
    return AdminHomeState(
      userList: userList ?? this.userList,
      searchText: searchText ?? this.searchText,
    );
  }
}
