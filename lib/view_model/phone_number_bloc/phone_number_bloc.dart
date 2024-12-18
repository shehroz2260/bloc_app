import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/services/auth_services.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view/auth_view/otp_screen.dart';
import 'phone_number_event.dart';
import 'phone_number_state.dart';

class PhoneNumberBloc extends Bloc<PhoneNumberEvent, PhoneNumberState> {
  PhoneNumberBloc() : super(PhoneNumberState(cCode: "+1")) {
    on<VerifyPhoneNumber>(_verifyPhoneNumber);
    on<OnCountryCodeChange>(_onCangeCountryCode);
  }
  _onCangeCountryCode(
      OnCountryCodeChange event, Emitter<PhoneNumberState> emit) {
    emit(state.copyWith(cCode: event.code.dialCode ?? ""));
  }

  _verifyPhoneNumber(
      VerifyPhoneNumber event, Emitter<PhoneNumberState> emit) async {
    LoadingDialog.showProgress(event.context);
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: "${state.cCode} ${event.controller.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (Platform.isAndroid) {
          var user = await auth.signInWithCredential(credential);
          final userModel = await AuthServices.isLoadData(event.context);
          LoadingDialog.hideProgress(event.context);
          var userM = event.context.read<UserBaseBloc>().state.userData;
          if (!userModel) {
            userM = userM.copyWith(
              uid: user.user?.uid ?? '',
              phoneNumber: "${state.cCode} ${event.controller.text}",
            );
            event.context
                .read<UserBaseBloc>()
                .add(UpdateUserEvent(userModel: userM));
            NetworkService.updateUser(userM);
          } else {
            LoadingDialog.hideProgress(event.context);
          }

          NetworkService.gotoHomeScreen(event.context);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        LoadingDialog.hideProgress(event.context);
        if (e.code == AppStrings.invalidPhoneNumber) {
          showOkAlertDialog(
              context: event.context,
              message: AppStrings.theProvidedPhoneNumberIsNotValid,
              title: "Error");
          return;
        }
        if (e.code == AppStrings.tooManyRequests) {
          showOkAlertDialog(
              context: event.context,
              message:
                  AppStrings.youHaveAttemptedTooManyRequestsPleaseTryAgainLater,
              title: AppStrings.smsVerificationError);

          return;
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        LoadingDialog.hideProgress(event.context);
        Go.to(
            event.context,
            OtpScreen(
              verificationID: verificationId,
              resendToken: resendToken ?? 0,
              phoneNumber: "${state.cCode} ${event.controller.text}",
            ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
