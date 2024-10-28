import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/thread_model.dart';
import '../../services/network_service.dart';
import 'inbox_event.dart';
import 'inbox_state.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  InboxBloc() : super(InboxState(threadList: [],unreadCount: 0,searchText: "")) {
    on<OnDispose>(_onDispose);
    on<ThreadListener>(_messageListener);
    on<TreadListenerStream>(_onChatListenerStream);
    on<MessageClearList>(_treadClearList);
    on<OnSearch>(_onSearch);
  }

_onSearch(OnSearch event , Emitter<InboxState> emit){
emit(state.copyWith(searchText: event.value));
}

_onDispose(OnDispose event , Emitter<InboxState> emit)async{
  emit(state.copyWith(threadList: []));
await subs?.cancel();

}

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subs;
  Stream<InboxState> _chatListenerStream(ThreadListener event,Emitter<InboxState> emit) async* {
   subs = FirebaseFirestore.instance.collection(ThreadModel.tableName).where("participantUserList",
            arrayContains: FirebaseAuth.instance.currentUser?.uid??"").snapshots().listen((value)async{
             add(MessageClearList());
     if (value.docs.isEmpty) return ;
     for(final e in value.docs){
 var chat = ThreadModel.fromMap(e.data());
var userModel = await NetworkService.getUserDetailById(
              chat.participantUserList[0] ==
                      (FirebaseAuth.instance.currentUser?.uid??"")
                  ? chat.participantUserList[1]
                  : chat.participantUserList[0]);
          chat.userDetail = userModel;
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
   final list = state.threadList.where((e)=> e.threadId == event.model.threadId).toList();
    if(list.isNotEmpty) return;
  state.threadList.add(event.model);

  emit(state.copyWith(threadList: state.threadList));

    // } 

}

_treadClearList (MessageClearList event , Emitter<InboxState>emit)async{
  emit(state.copyWith(threadList: []));
}
}
