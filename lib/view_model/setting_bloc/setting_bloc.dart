import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/services/local_storage_service.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'setting_event.dart';
import 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingState(isOnNotification: false)) {
    on<OnNotificationEvent>(_onNotification);
    on<OninitSetting>(_oninitSetting);
  }
  _onNotification(OnNotificationEvent event, Emitter<SettingState> emit) async {
    if (!state.isOnNotification) {
      if (!await handleLocationPermission(event.context)) return;
      var userBloc = event.context.read<UserBaseBloc>();
      emit(state.copyWith(isOnNotification: event.isOn));
      var user = userBloc.state.userData;
      user = user.copyWith(isOnNotification: event.isOn);
      userBloc.add(UpdateUserEvent(userModel: user));
      NetworkService.updateUser(user);
      LocalStorageService.storage
          .write(LocalStorageService.notificationPermission, true);
    } else {
      var userBloc = event.context.read<UserBaseBloc>();
      emit(state.copyWith(isOnNotification: event.isOn));
      var user = userBloc.state.userData;
      user = user.copyWith(isOnNotification: event.isOn);
      userBloc.add(UpdateUserEvent(userModel: user));
      NetworkService.updateUser(user);
      LocalStorageService.storage
          .remove(LocalStorageService.notificationPermission);
    }
  }

  _oninitSetting(OninitSetting event, Emitter<SettingState> emit) {
    emit(state.copyWith(
        isOnNotification: event.context
            .read<UserBaseBloc>()
            .state
            .userData
            .isOnNotification));
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    final allowed = await Permission.notification.request().isGranted;
    if (!allowed) {
      var res = await showOkCancelAlertDialog(
          context: context,
          message: "Please allow notification permission from app setting",
          cancelLabel: "Cancel",
          okLabel: "Open settings",
          title: "Permission denied");
      if (res == OkCancelResult.cancel) return false;
      openAppSettings();
      return false;
    }
    return true;
  }
}
