import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/repos/get_all_users.dart';
import 'inbox_event.dart';
import 'inbox_state.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  InboxBloc() : super(InboxState(threadList: [])) {
    on<OnInitEvent>(_oninitEvent);
  }
  _oninitEvent(OnInitEvent event, Emitter<InboxState> emit)async{
final userList = await GetAllUsers.getAllUser();
emit(state.copyWith(threadList: userList));

  }
}
