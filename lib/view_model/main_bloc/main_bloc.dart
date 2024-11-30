import 'dart:async';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user_model.dart';
import '../../services/local_storage_service.dart';
import '../../services/network_service.dart';
import '../../view/on_boarding_view/un_verified_view.dart';
import '../matches_bloc/matches_bloc.dart';
import '../matches_bloc/matches_event.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState(currentIndex: 0)) {
    on<ChangeIndexEvent>(_onUpdateIndex);
    on<ListernerChanges>(_onChangeListener);
    on<OninitNotification>(_oninitNotifications);
    on<OnDispose>(_onDispose);
  }
  _onUpdateIndex(ChangeIndexEvent event, Emitter<MainState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? sub;
  _onChangeListener(ListernerChanges event, Emitter<MainState> emit) {
    sub = FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
        .snapshots()
        .listen((e) async {
      var user = UserModel.fromMap(e.data() ?? {});
      if (!user.isVerified) {
        Go.offAll(event.context, const UnVerifiedView());
      }
      event.context.read<MatchesBloc>().add(ONinit(bloc: user));
      event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
    });
  }

  _onDispose(OnDispose event, Emitter<MainState> emit) async {
    await sub?.cancel();
  }

  _oninitNotifications(
      OninitNotification event, Emitter<MainState> emit) async {
    final userBloc = event.context.read<UserBaseBloc>();
    bool isAllowed = LocalStorageService.storage
            .read(LocalStorageService.notificationPermission) ??
        false;

    if (isAllowed) {
      var user = userBloc.state.userData;
      user = user.copyWith(isOnNotification: true);
      userBloc.add(UpdateUserEvent(userModel: user));
      NetworkService.updateUser(user);
    } else {
      var user = userBloc.state.userData;
      user = user.copyWith(isOnNotification: false);
      userBloc.add(UpdateUserEvent(userModel: user));
      NetworkService.updateUser(user);
    }
  }
}
