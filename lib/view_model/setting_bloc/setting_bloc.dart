import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'setting_event.dart';
import 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingState(isOnNotification: false)) {
    on<OnNotificationEvent>(_onNotification);
    on<OninitSetting>(_oninitSetting);
  }
  _onNotification(OnNotificationEvent event, Emitter<SettingState> emit) {
    emit(state.copyWith(isOnNotification: event.isOn));
    var userBloc = event.context.read<UserBaseBloc>();
    var user = userBloc.state.userData;
    user = user.copyWith(isOnNotification: event.isOn);
    userBloc.add(UpdateUserEvent(userModel: user));
    NetworkService.updateUser(user);
  }

  _oninitSetting(OninitSetting event, Emitter<SettingState> emit) {
    emit(state.copyWith(
        isOnNotification: event.context
            .read<UserBaseBloc>()
            .state
            .userData
            .isOnNotification));
  }
}
