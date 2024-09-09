// ignore_for_file: use_build_context_synchronously
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/utils/custom_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../user_base_bloc/user_base_bloc.dart';
import '../user_base_bloc/user_base_event.dart';
import '../../model/user_model.dart';
import '../../services/auth_services.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState(borderClr: AppColors.whiteColor)) {
    on<ImagePickerEvent>(_onImagePickr);
    on<OnSignUpEvent>(_onSignUp);
    on<BorderColorChange>(_onRedBorderClr);
  }
  _onImagePickr(ImagePickerEvent event ,Emitter<SignUpState>emit)async{
    final file = await kImagePicker(context: event.context);
    if(file != null){
      emit(state.copyWith(image: file,borderClr: AppColors.whiteColor));
    }
  }
  _onSignUp(OnSignUpEvent event , Emitter<SignUpState>emit)async{
    if(state.image == null){
      event.context.read<SignUpBloc>().add(BorderColorChange());
    }
    if(!event.formKey.currentState!.validate() || state.image == null){
      return;
    }
 FocusScope.of(event.context).requestFocus(FocusNode());
      LoadingDialog.showProgress(event.context);
    try {
      UserModel user = UserModel(
          name: event.nameController.text,
          email: event.emailController.text,
          profileImage: state.image?.path??"",
          uid: "",
          location: "",
          lat: 0,
          lng: 0,
          gender: 0,
          dob: DateTime(1800),
          matches: [],
          myDislikes: [],
          myLikes: [],
          otherDislikes: [],
          otherLikes: [],
          preferGender: -1,
          );
      user.password = event.passwordController.text;
      event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
      await AuthServices.signupUser(user,event.context);
      emit(state.copyWith(image: null));
      event.nameController.clear();
      event.emailController.clear();
      event.passwordController.clear();
      LoadingDialog.hideProgress(event.context);
     
NetworkService.gotoHomeScreen(event.context);
  
    } on FirebaseAuthException catch (e) {
      LoadingDialog.hideProgress(event.context);
    showOkAlertDialog(context: event.context,title: "Error",message: e.message??"");
      

      if (kDebugMode) {
        print(e);
      }
    } on Exception catch (e) {
      LoadingDialog.hideProgress(event.context);

      if (kDebugMode) {
        print(e.toString());
      }

       showOkAlertDialog(context: event.context,title: "Error",message: e.toString());
    }
  }
  _onRedBorderClr(BorderColorChange event , Emitter<SignUpState>emit){
    emit(state.copyWith(borderClr: Colors.red));
  }
}
