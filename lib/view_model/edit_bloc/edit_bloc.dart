import 'dart:io';
import 'package:chat_with_bloc/services/firebase_services_storage.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/custom_image_picker.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../src/app_colors.dart';
import 'edit_event.dart';
import 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc()
      : super(EditState(imageFile: null, isEdit: false, dob: DateTime(1800))) {
    on<ImagesPick>(_onPickImage);
    on<OndisPose>(_onDisPose);
    on<OpenEditTextField>(_onEditOpen);
    on<UpdateUser>(_onUpdateUser);
    on<OnPickDateTime>(_onDatePicker);
  }

  _onPickImage(ImagesPick event, Emitter<EditState> emit) async {
    final file = await kImagePicker(context: event.context);
    if (file != null) {
      emit(state.copyWith(imageFile: file));
    }
  }

  _onDisPose(OndisPose event, Emitter<EditState> emit) async {
    emit(state.copyWith(
        imageFile: File(""), isEdit: false, dob: DateTime(1800)));
  }

  _onEditOpen(OpenEditTextField event, Emitter<EditState> emit) {
    emit(state.copyWith(isEdit: !state.isEdit));
  }

  _onUpdateUser(UpdateUser event, Emitter<EditState> edit) async {
    var user = event.context.read<UserBaseBloc>().state.userData;
    String url = user.profileImage;
    DateTime date = user.dob;
    LoadingDialog.showProgress(event.context);
    if ((state.imageFile?.path ?? "").isNotEmpty) {
      url = await FirebaseStorageService()
          .uploadImage("profile${user.uid}", state.imageFile?.path ?? "");
    }
    if (state.dob != DateTime(1800)) {
      date = state.dob;
    }
    user = user.copyWith(
        about: event.about,
        bio: event.bio,
        lastName: event.lastName,
        firstName: event.firstName,
        profileImage: url,
        dob: date);
    NetworkService.updateUser(user);
    LoadingDialog.hideProgress(event.context);
    Go.back(event.context);
  }

  _onDatePicker(OnPickDateTime event, Emitter<EditState> emit) async {
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
    if (date == null) return;
    emit(state.copyWith(dob: date));
  }
}
