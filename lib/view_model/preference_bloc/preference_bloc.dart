import 'package:chat_with_bloc/model/filter_model.dart';
import 'package:chat_with_bloc/repos/filter_repo.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/view/main_view/main_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'preference_event.dart';
import 'preference_state.dart';

class PreferenceBloc extends Bloc<PreferenceEvent, PreferenceState> {
  PreferenceBloc() : super(PreferenceState(prefGenders: -1)) {
    on<PickGenders>(_onPickGender);
    on<OnNextEvent>(_onNext);
  }

  _onPickGender(PickGenders event , Emitter<PreferenceState>emit){
   emit(state.copyWith(prefGenders: event.gender));
  }
  _onNext(OnNextEvent event , Emitter<PreferenceState>emit){
    if(state.prefGenders == -1){
      showOkAlertDialog(context: event.context, message: "Please select on gender",title: "Error");
      return;
    }
    LoadingDialog.showProgress(event.context);
    var user = event.context.read<UserBaseBloc>().state.userData;
    user = user.copyWith(preferGender: state.prefGenders);
    FilterModel filterModel = FilterModel(minAge: 18, maxAge: 50, intrestedIn: state.prefGenders, distance: 50);
    event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
    NetworkService.updateUser(user);
    FilterRepo.setFilter(filterModel, event.context);
    LoadingDialog.hideProgress(event.context);
    emit(state.copyWith(prefGenders: -1));
    Go.offAll(event.context, const MainView());
  }
}
