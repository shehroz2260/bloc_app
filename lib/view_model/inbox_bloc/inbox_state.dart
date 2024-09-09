// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_with_bloc/model/user_model.dart';

class InboxState {
  final List<UserModel> threadList;
  InboxState({
    required this.threadList,
  });

  InboxState copyWith({
    List<UserModel>? threadList,
  }) {
    return InboxState(
      threadList: threadList ?? this.threadList,
    );
  }
 }
