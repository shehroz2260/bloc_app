import 'package:chat_with_bloc/model/user_model.dart';
abstract class UserBaseEvent {}
class UpdateUserEvent extends UserBaseEvent {
  final UserModel userModel;
  UpdateUserEvent({
    required this.userModel,
  });
}
