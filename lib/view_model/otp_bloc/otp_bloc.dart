import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_services.dart';
import '../../services/network_service.dart';
import '../user_base_bloc/user_base_bloc.dart';
import '../user_base_bloc/user_base_event.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpState(timer: 59)) {
    on<ScheduleTimer>(_scheduleTime);
    on<VerifyOtp>(_verifyOtp);
    on<ResendCode>(_resendToken);
    on<UpdateTimer>(_onUpdateTimer);
  }



  _verifyOtp(VerifyOtp event, Emitter<OtpState>emit)async{
 LoadingDialog.showProgress(event.context);
    var auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: event.verificationId, smsCode: event.otpController.text);
      var user = await auth.signInWithCredential(credential);
          final userModel = await AuthServices.isLoadData(event.context);
          LoadingDialog.hideProgress(event.context);
            var userM = event.context.read<UserBaseBloc>().state.userData;
          if (!userModel) {
            userM = userM.copyWith(
              uid: user.user?.uid ?? '',
              phoneNumber: event.phoneNumber,
            );
            event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: userM));
            NetworkService.updateUser(userM);
          } else {
            LoadingDialog.hideProgress(event.context);
          }

          NetworkService.gotoHomeScreen(event.context);
    } on FirebaseException catch (e) {
      LoadingDialog.hideProgress(event.context);
      showOkAlertDialog(context: event.context,message: e.message,title: ErrorStrings.smsVerificationError);
    }
  }

  _resendToken(ResendCode event , Emitter<OtpState>emit)async{

        if (state.timer != 0) return;
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      LoadingDialog.showProgress(event.context);
          emit(state.copyWith(timer: 59));
      await auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          LoadingDialog.hideProgress(event.context);
          await auth.signInWithCredential(credential);
        },
        forceResendingToken: event.resendToken,
        codeAutoRetrievalTimeout: (String codeverificationId) {
          codeverificationId = event.verificationId;
        },
        verificationFailed: (FirebaseAuthException e) {
          LoadingDialog.hideProgress(event.context);

          if (e.code == ErrorStrings.invalidPhoneNumber) {
            showOkAlertDialog(context: event.context,message: ErrorStrings.theProvidedPhoneNumberIsNotValid,title: "Error");
            return;
          }
          if (e.code == ErrorStrings.tooManyRequests) {
            showOkAlertDialog(context: event.context,message: ErrorStrings.youHaveAttemptedTooManyRequestsPleaseTryAgainLater,title: ErrorStrings.smsVerificationError);
            return;
          }
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          LoadingDialog.hideProgress(event.context);

          add(ScheduleTimer());
        },
      );
    } on FirebaseException catch (e) {
          LoadingDialog.hideProgress(event.context);
  showOkAlertDialog(context: event.context,message: e.message,title: "Error");
    }
  }

  ////////////////////////////////////////////////////////////////////
  _onUpdateTimer(UpdateTimer timer,Emitter<OtpState>emit ){
    emit(state.copyWith(timer: timer.time));
  }
    _scheduleTime(ScheduleTimer event , Emitter<OtpState>emit)async{
    await emit.forEach(_updateTime(emit), onData: (value){
      return state.copyWith(timer: value.timer);
    });
   
  }
    Stream<OtpState> _updateTime(Emitter<OtpState>emit) async* {
      int timee = state.timer;
   Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    if(state.timer == 0){
      timer.cancel();
      return;
    }
    timee --;
    add(UpdateTimer(time: timee));
  });
}
}
