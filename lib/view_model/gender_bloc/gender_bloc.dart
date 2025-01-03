import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view/account_creation_view/preference_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'gender_event.dart';
import 'gender_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenderBloc extends Bloc<GenderEvent, GenderState> {
  GenderBloc() : super(GenderState(gender: 0)) {
    on<PickGender>(_onPickGender);
    on<OnNextEvent>(_onNext);
    on<OninitGender>(_onint);
  }
  _onPickGender(PickGender event, Emitter<GenderState> emit) {
    emit(state.copyWith(gender: event.gender));
  }

  _onNext(OnNextEvent event, Emitter<GenderState> emit) {
    if (state.gender == 0) {
      showOkAlertDialog(
          context: event.context,
          message: AppLocalizations.of(event.context)!.pickOneGender,
          title: "Error");
      return;
    }
    LoadingDialog.showProgress(event.context);
    var user = event.context.read<UserBaseBloc>().state.userData;
    user = user.copyWith(gender: state.gender);
    event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
    NetworkService.updateUser(user);
    LoadingDialog.hideProgress(event.context);
    emit(state.copyWith(gender: 0));
    if (!event.isUpdate) {
      Go.to(event.context, const PreferenceView());
    } else {
      Go.back(event.context);
    }
  }

  _onint(OninitGender event, Emitter<GenderState> emit) {
    emit(state.copyWith(
        gender: event.context.read<UserBaseBloc>().state.userData.gender));
  }
}
