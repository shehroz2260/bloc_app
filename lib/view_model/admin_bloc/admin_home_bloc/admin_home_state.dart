import 'package:chat_with_bloc/model/user_model.dart';

class AdminHomeState {
  final List<UserModel> userList;
  final String searchText;
  final bool isVerify;
  AdminHomeState({
    required this.userList,
    required this.searchText,
    required this.isVerify,
  });

  AdminHomeState copyWith({
    List<UserModel>? userList,
    String? searchText,
    bool? isVerify,
  }) {
    return AdminHomeState(
      userList: userList ?? this.userList,
      searchText: searchText ?? this.searchText,
      isVerify: isVerify ?? this.isVerify,
    );
  }
}
