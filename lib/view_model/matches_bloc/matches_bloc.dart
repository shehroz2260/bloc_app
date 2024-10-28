import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'matches_event.dart';
import 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  MatchesBloc() : super(MatchesState(index: 0,likesList: [],matchedList: [])) {
    on<ChangeIndex>(_onChangeIndex);
    on<ONinit>(_onInit);
    on<ClearList>(_clearList);
  }

  _onChangeIndex(ChangeIndex event , Emitter<MatchesState>emit){
    emit(state.copyWith(index: event.index));
  }

  _onInit(ONinit event, Emitter<MatchesState> emit)async{
  add(ClearList());
try{
  for(final likes in event.bloc.otherLikes){
    final model = await NetworkService.getUserDetailById(likes);
    state.likesList.add(model);
    emit(state.copyWith(likesList: state.likesList));
  }
   for(final match in event.bloc.matches){
    final model = await NetworkService.getUserDetailById(match);
    state.matchedList.add(model);
    emit(state.copyWith(matchedList: state.matchedList));
  }

}on FirebaseException catch (e){
log("message: ${e.message}");
}
  }

  _clearList(ClearList event, Emitter<MatchesState>emit){
    emit(state.copyWith(likesList: [], matchedList: []));
  }
}
