// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_with_bloc/model/thread_model.dart';

class InboxState {
  final List<ThreadModel> threadList;
  final int unreadCount;
  InboxState( {
    required this.threadList,
    required this.unreadCount,
  });

  InboxState copyWith({
    List<ThreadModel>? threadList,
    int? unreadCount,
  }) {
    return InboxState(
      unreadCount: unreadCount ?? this.unreadCount,
      threadList: threadList ?? this.threadList,
    );
  }
 }
