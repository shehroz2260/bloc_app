import 'package:chat_with_bloc/model/user_model.dart';
class UserBaseState {
  final UserModel userData;
  UserBaseState({
    required this.userData,
  });

  UserBaseState copyWith({
    UserModel? userData,
  }) {
    return UserBaseState(
      userData: userData ?? this.userData,
    );
  }
 }
