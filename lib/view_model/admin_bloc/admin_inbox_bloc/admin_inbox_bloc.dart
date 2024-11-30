import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../model/thread_model.dart';
import '../../../services/network_service.dart';
import '../../inbox_bloc/inbox_state.dart';
import 'admin_inbox_event.dart';
import 'admin_inbox_state.dart';

class AdminInboxBloc extends Bloc<AdminInboxEvent, AdminInboxState> {
  AdminInboxBloc() : super(AdminInboxState(adminThreadList: [])) {
    on<OnDispose>(_onDispose);
    on<ThreadListener>(_messageListener);
    on<TreadListenerStream>(_onChatListenerStream);
    on<MessageClearList>(_treadClearList);
  }

  _onDispose(OnDispose event, Emitter<AdminInboxState> emit) async {
    emit(state.copyWith(adminThreadList: []));
    await subs?.cancel();
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subs;
  Stream<InboxState> _chatListenerStream(
      ThreadListener event, Emitter<AdminInboxState> emit) async* {
    subs = FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .where("participantUserList",
            arrayContains: FirebaseAuth.instance.currentUser?.uid ?? "")
        .where("isAdmin", isEqualTo: true)
        .snapshots()
        .listen((value) async {
      add(MessageClearList());
      if (value.docs.isEmpty) return;
      for (final e in value.docs) {
        var chat = ThreadModel.fromMap(e.data());
        var userModel = await NetworkService.getUserDetailById(
            chat.participantUserList[0] ==
                    (FirebaseAuth.instance.currentUser?.uid ?? "")
                ? chat.participantUserList[1]
                : chat.participantUserList[0]);
        chat.userDetail = userModel;
        add(TreadListenerStream(model: chat));
      }
    });
  }

  _messageListener(ThreadListener event, Emitter<AdminInboxState> emit) async {
    await emit.forEach(_chatListenerStream(event, emit), onData: (value) {
      return state.copyWith(adminThreadList: value.threadList);
    });
  }

  _onChatListenerStream(
      TreadListenerStream event, Emitter<AdminInboxState> emit) {
    final list = state.adminThreadList
        .where((e) => e.threadId == event.model.threadId)
        .toList();
    if (list.isNotEmpty) return;
    state.adminThreadList.add(event.model);

    emit(state.copyWith(adminThreadList: state.adminThreadList));
  }

  _treadClearList(MessageClearList event, Emitter<AdminInboxState> emit) async {
    emit(state.copyWith(adminThreadList: []));
  }
}
