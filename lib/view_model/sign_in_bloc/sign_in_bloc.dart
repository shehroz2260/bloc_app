// ignore_for_file: use_build_context_synchronously
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInState()) {
    on<OnSigninEvent>(_onSignin);
    on<OnGooglesignin>(_onGoogleSignin);
  }
  _onSignin(OnSigninEvent event, Emitter<SignInState> emit) async {
    if (!event.formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(event.context).requestFocus(FocusNode());

    LoadingDialog.showProgress(event.context);
    try {
      await AuthServices.loginUser(
          event.emailController.text, event.passwordController.text);
      event.emailController.clear();
      event.passwordController.clear();
      LoadingDialog.hideProgress(event.context);
      NetworkService.gotoHomeScreen(event.context);
    } on FirebaseAuthException catch (e) {
      LoadingDialog.hideProgress(event.context);
      showOkAlertDialog(
          context: event.context, message: e.message ?? "", title: "Error");
      if (kDebugMode) {
        print(e);
      }
    } on Exception catch (e) {
      LoadingDialog.hideProgress(event.context);
      if (kDebugMode) {}
      showOkAlertDialog(
          context: event.context, message: e.toString(), title: "Error");
    }
  }

  _onGoogleSignin(OnGooglesignin event, Emitter<SignInState> emit) async {
    try {
      LoadingDialog.showProgress(event.context);
      var isUser = await AuthServices.loginWithGoogle(event.context) ?? false;

      LoadingDialog.hideProgress(event.context);

      if (isUser) {
        NetworkService.gotoHomeScreen(event.context);
      }
    } on FirebaseAuthException catch (e) {
      LoadingDialog.hideProgress(event.context);
      showOkAlertDialog(
          context: event.context, message: e.message, title: "Error!");

      if (kDebugMode) {
        print(e);
      }
    } on Exception catch (e) {
      LoadingDialog.hideProgress(event.context);

      if (kDebugMode) {
        print(e.toString());
      }
      showOkAlertDialog(
          context: event.context, message: e.toString(), title: "Error!");
    }
  }
}
