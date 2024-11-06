import 'dart:async';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user_model.dart';
import '../../view/main_view/chat_tab/inbox_view.dart';
import '../../view/main_view/home_tab/home_view.dart';
import '../../view/main_view/match_tab/match_view.dart';
import '../../view/main_view/profile_tab/profile_view.dart';
import '../matches_bloc/matches_bloc.dart';
import '../matches_bloc/matches_event.dart';
import 'main_event.dart';
import 'main_state.dart';

List<Widget> _tabList = const [
  HomeView(),
  //  MapScreen(),
  MatchTab(),
  InboxView(),
  ProfileView(),
];

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc()
      : super(MainState(
            currentBody: IndexedStack(index: 0, children: _tabList),
            currentIndex: 0)) {
    on<ChangeIndexEvent>(_onUpdateIndex);
    on<ListernerChanges>(_onChangeListener);
    on<OnDispose>(_onDispose);
  }
  _onUpdateIndex(ChangeIndexEvent event, Emitter<MainState> emit) {
    emit(state.copyWith(
        currentBody: IndexedStack(index: event.index, children: _tabList),
        currentIndex: event.index));
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? sub;
  _onChangeListener(ListernerChanges event, Emitter<MainState> emit) {
    sub = FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
        .snapshots()
        .listen((e) async {
      var user = UserModel.fromMap(e.data() ?? {});
      event.context.read<MatchesBloc>().add(ONinit(bloc: user));

      event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
    });
  }

  _onDispose(OnDispose event, Emitter<MainState> emit) async {
    await sub?.cancel();
  }
}
