// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_with_bloc/model/thread_model.dart';

class InboxState {
  final List<ThreadModel> threadList;
  final int unreadCount;
 final String searchText;
  InboxState( {
    required this.threadList,
    required this.searchText,
    required this.unreadCount,
  });

  InboxState copyWith({
    List<ThreadModel>? threadList,
    String? searchText,
    int? unreadCount,
  }) {
    return InboxState(
      unreadCount: unreadCount ?? this.unreadCount,
      searchText: searchText ?? this.searchText,
      threadList: threadList ?? this.threadList,
    );
  }
 }
