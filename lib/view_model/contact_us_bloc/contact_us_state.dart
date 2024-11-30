import 'package:chat_with_bloc/model/thread_model.dart';

class ContactUsState {
  final List<ThreadModel> adminThreadList;
  ContactUsState({
    required this.adminThreadList,
  });

  ContactUsState copyWith({
    List<ThreadModel>? adminThreadList,
  }) {
    return ContactUsState(
      adminThreadList: adminThreadList ?? this.adminThreadList,
    );
  }
}
