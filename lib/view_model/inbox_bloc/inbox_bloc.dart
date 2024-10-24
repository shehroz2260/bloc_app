import 'dart:async';

import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/thread_model.dart';
import '../../services/network_service.dart';
import 'inbox_event.dart';
import 'inbox_state.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  InboxBloc() : super(InboxState(threadList: [],unreadCount: 0)) {
    on<OnDispose>(_onDispose);
    on<ThreadListener>(_messageListener);
    on<TreadListenerStream>(_onChatListenerStream);
    on<MessageClearList>(_treadClearList);
  }


_onDispose(OnDispose event , Emitter<InboxState> emit)async{
  emit(state.copyWith(threadList: []));
await subs?.cancel();

}

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subs;
  Stream<InboxState> _chatListenerStream(ThreadListener event,Emitter<InboxState> emit) async* {
   subs = FirebaseFirestore.instance.collection(ThreadModel.tableName).where("participantUserList",
            arrayContains: event.context.read<UserBaseBloc>().state.userData.uid).snapshots().listen((value)async{
             add(MessageClearList());
     if (value.docs.isEmpty) return ;
     for(final e in value.docs){
 var chat = ThreadModel.fromMap(e.data());
var userModel = await NetworkService.getUserDetailById(
              chat.participantUserList[0] ==
                      event.context.read<UserBaseBloc>().state.userData.uid
                  ? chat.participantUserList[1]
                  : chat.participantUserList[0]);
          chat.userDetail = userModel;
          if ((chat.messageCount ) > 0 &&
              chat.senderId != event.context.read<UserBaseBloc>().state.userData.uid) {
                state.copyWith(unreadCount: state.unreadCount +1);
          }   
 add(TreadListenerStream(model: chat));
     }
           
  });
}
   _messageListener(ThreadListener event , Emitter<InboxState>emit)async{
  await  emit.forEach(
     _chatListenerStream(event,emit), onData: (value){
        return  state.copyWith(threadList: value.threadList);
        });
  }
  _onChatListenerStream(TreadListenerStream event , Emitter<InboxState>emit){
    // if(!state.threadList.contains(event.model)){
  state.threadList.add(event.model);
  emit(state.copyWith(threadList: state.threadList));
    // } 

}

_treadClearList (MessageClearList event , Emitter<InboxState>emit){
  emit(state.copyWith(threadList: []));
}
}
