import 'package:chat_with_bloc/model/thread_model.dart';

class AdminInboxState {
  final List<ThreadModel> adminThreadList;
  AdminInboxState({
    required this.adminThreadList,
  });

  AdminInboxState copyWith({
    List<ThreadModel>? adminThreadList,
  }) {
    return AdminInboxState(
      adminThreadList: adminThreadList ?? this.adminThreadList,
    );
  }
}
