import 'package:chat_with_bloc/services/firebase_services_storage.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view/account_creation_view/gender_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import '../../src/app_colors.dart';
import '../../utils/custom_image_picker.dart';
import '../user_base_bloc/user_base_event.dart';
import 'dob_event.dart';
import 'dob_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DobBloc extends Bloc<DobEvent, DobState> {
  DobBloc() : super(DobState(dateString: "",imgString: "")) {
    on<DatePickerEvent>(_onDatePicker);
    on<OnNextEvent>(_onNext);
    on<ImagePickerEvent>(_onImagePickr);
  }
  _onImagePickr(ImagePickerEvent event ,Emitter<DobState>emit)async{
    final file = await kImagePicker(context: event.context);
    if(file != null){
      emit(state.copyWith(image: file,imgString: ""));
    }
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
      slidersColor: AppColors.redColor,
      slidersSize: 20,
      splashColor: AppColors.redColor,
      splashRadius: 40,
      centerLeadingDate: true,
    );
    if(date == null) return;
    emit(state.copyWith(dob: date,dateString: ""));
  }

  _onNext(OnNextEvent event, Emitter<DobState>emit)async{
    if(state.image == null){
      emit(state.copyWith(imgString: "Image is required"));
    }
     if(state.dob == null){
      emit(state.copyWith(dateString: "Dob is required"));
    }
    if(!event.formKey.currentState!.validate() || state.image == null || state.dob == null) return;
LoadingDialog.showProgress(event.context);
    var user = event.context.read<UserBaseBloc>().state.userData;
    final url =await FirebaseStorageService().uploadImage("profile/${user.uid}", state.image?.path??"");
    user = user.copyWith(dob: state.dob,profileImage: url, firstName: event.nameController.text);
     event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
    NetworkService.updateUser(user);
    event.nameController.clear();
    emit(state.copyWith(dob: null, image: null));
LoadingDialog.hideProgress(event.context);
    Go.to(event.context, const GenderView());
  }
}
