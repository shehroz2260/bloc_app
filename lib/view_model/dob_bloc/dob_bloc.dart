import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view/onboarding_views/gender_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../src/app_colors.dart';
import '../user_base_bloc/user_base_event.dart';
import 'dob_event.dart';
import 'dob_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DobBloc extends Bloc<DobEvent, DobState> {
  DobBloc() : super(DobState(dob: DateTime(1800))) {
    on<DatePickerEvent>(_onDatePicker);
    on<OnNextEvent>(_onNext);
  }
  _onDatePicker(DatePickerEvent event , Emitter<DobState>emit)async{
     final date = await showDatePickerDialog(
      context: event.context,
      initialDate: DateTime(2000, 01, 01),
      minDate: DateTime(1950, 01, 01),
      maxDate: DateTime.now(),
      width: 300,
      height: 300,
      currentDate: DateTime(2022, 10, 15),
      selectedDate: DateTime(2022, 10, 16),
      currentDateDecoration: const BoxDecoration(),
      currentDateTextStyle: const TextStyle(),
      daysOfTheWeekTextStyle: const TextStyle(),
      disabledCellsTextStyle: const TextStyle(),
      enabledCellsDecoration: const BoxDecoration(),
      enabledCellsTextStyle: const TextStyle(),
      initialPickerType: PickerType.days,
      selectedCellDecoration: const BoxDecoration(),
      selectedCellTextStyle: const TextStyle(),
      leadingDateTextStyle: const TextStyle(),
      slidersColor: AppColors.blueColor,
      slidersSize: 20,
      splashColor: AppColors.blueColor,
      splashRadius: 40,
      centerLeadingDate: true,
    );
    if(date == null) return;
     final text = DateFormat("dd MMM yyyy").format(date);
     event.textEditingController.text = text;
    emit(state.copyWith(dob: date));
  }

  _onNext(OnNextEvent event, Emitter<DobState>emit){
    if(!event.formKey.currentState!.validate())return;
LoadingDialog.showProgress(event.context);
    var user = event.context.read<UserBaseBloc>().state.userData;
    user = user.copyWith(dob: state.dob);
     event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
    NetworkService.updateUser(user);
LoadingDialog.hideProgress(event.context);
    Go.to(event.context, const GenderView());
  }
}
