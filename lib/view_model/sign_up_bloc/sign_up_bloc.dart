// ignore_for_file: use_build_context_synchronously
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/services/network_service.dart';
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
  SignUpBloc() : super(SignUpState()) {
    on<OnSignUpEvent>(_onSignUp);
  }

  _onSignUp(OnSignUpEvent event, Emitter<SignUpState> emit) async {
    if (!event.formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(event.context).requestFocus(FocusNode());
    LoadingDialog.showProgress(event.context);
    try {
      UserModel user = UserModel(
        phoneNumber: "",
        email: event.emailController.text,
        profileImage: "",
        uid: "",
        lastName: "",
        firstName: "",
        isOnline: false,
        isVerified: true,
        isShowLocation: true,
        isAdmin: false,
        ignitoMode: false,
        isOnNotification: false,
        location: "",
        cusId: "",
        fcmToken: "",
        lat: 0,
        lng: 0,
        gender: 0,
        dob: DateTime(1800),
        about: "",
        bio: "",
        galleryImages: [],
        matches: [],
        myDislikes: [],
        myInstrest: [],
        myLikes: [],
        otherDislikes: [],
        otherLikes: [],
        preferGender: -1,
      );
      user.password = event.passwordController.text;
      event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
      await AuthServices.signupUser(user, event.context);
      event.emailController.clear();
      event.passwordController.clear();
      LoadingDialog.hideProgress(event.context);

      NetworkService.gotoHomeScreen(event.context);
    } on FirebaseAuthException catch (e) {
      LoadingDialog.hideProgress(event.context);
      showOkAlertDialog(
          context: event.context, title: "Error", message: e.message ?? "");

      if (kDebugMode) {
        print(e);
      }
    } on Exception catch (e) {
      LoadingDialog.hideProgress(event.context);

      if (kDebugMode) {
        print(e.toString());
      }

      showOkAlertDialog(
          context: event.context, title: "Error", message: e.toString());
    }
  }
}
