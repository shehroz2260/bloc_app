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
  }

  _scheduleTime(ScheduleTimer event , Emitter<OtpState>emit){
    int timers = state.timer;
     Timer.periodic(const Duration(seconds: 1), (time) async {
      if (state.timer == 0) {
        time.cancel();
        return;
      }
      timers--;
      emit(state.copyWith(timer: timers));
    });
  }

  _verifyOtp(VerifyOtp event, Emitter<OtpState>emit)async{
 LoadingDialog.showProgress(event.context);
    var auth = FirebaseAuth.instance;
    // otpString.value =
    //     otp1.text + otp2.text + otp3.text + otp4.text + otp5.text + otp6.text;
    // if (_otpController.text.length != 6) {
    //   _baseController.hideProgress();
    //   CustomDialogue().customOkDialogue(
    //     title: AppLanguage.error,
    //     message: AppLanguage.pleaseEnterValidOtp,
    //   );
    //   return;
    // }

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
}
