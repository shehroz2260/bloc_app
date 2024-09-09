import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/view/main_view/map_tab/map_view.dart';
import 'package:flutter/material.dart';
import '../../view/main_view/chat_tab/inbox_view.dart';
import '../../view/main_view/home_tab/home_view.dart';
import '../../view/main_view/profile_tab/profile_view.dart';
import 'main_event.dart';
import 'main_state.dart';

  List<Widget> _tabList = const [
     HomeView(),
     MapScreen(),
     InboxView(),
     ProfileView(),
  ];
class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState(currentBody: IndexedStack(index: 0, children: _tabList),currentIndex: 0)) {
    on<ChangeIndexEvent>(_onUpdateIndex);
  }
  _onUpdateIndex(ChangeIndexEvent event, Emitter<MainState>emit){
emit(
  state.copyWith(currentBody: IndexedStack(index: event.index, children: _tabList),currentIndex: event.index)
);
  }
}
