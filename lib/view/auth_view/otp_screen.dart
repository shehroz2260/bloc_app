import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/otp_bloc/otp_bloc.dart';
import 'package:chat_with_bloc/view_model/otp_bloc/otp_event.dart';
import 'package:chat_with_bloc/view_model/otp_bloc/otp_state.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtpScreen extends StatefulWidget {
  final String verificationID;
  final String phoneNumber;
  final int resendToken;
  const OtpScreen(
      {super.key,
      required this.verificationID,
      required this.phoneNumber,
      required this.resendToken});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<OtpBloc>().add(ScheduleTimer());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: BlocBuilder<OtpBloc, OtpState>(builder: (context, state) {
            return Column(
              children: [
                const AppHeight(height: 70),
                const Align(
                    alignment: Alignment.centerLeft, child: CustomBackButton()),
                const AppHeight(height: 30),
                Text("00:${state.timer}",
                    style: AppTextStyle.font30
                        .copyWith(color: AppColors.blackColor)),
                Text(
                    AppLocalizations.of(context)!
                        .typeTheVerificationCodeWeHaveSentyou,
                    style: AppTextStyle.font16
                        .copyWith(color: AppColors.blackColor)),
                const AppHeight(height: 30),
                Pinput(
                  validator: (value) {
                    if ((value ?? "").isEmpty) {
                      return AppLocalizations.of(context)!.enterpin;
                    }
                    if ((value ?? "").length < 6) {
                      return AppLocalizations.of(context)!.enterValidPin;
                    }
                    return null;
                  },
                  controller: _otpController,
                  cursor: Container(
                    height: 20,
                    width: 2,
                    color: AppColors.redColor,
                  ),
                  submittedPinTheme: PinTheme(
                      textStyle: AppTextStyle.font25,
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: AppColors.redColor,
                          border:
                              Border.all(color: AppColors.redColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)))),
                  focusedPinTheme: PinTheme(
                      textStyle: AppTextStyle.font25,
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border:
                              Border.all(color: AppColors.redColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)))),
                  defaultPinTheme: PinTheme(
                      textStyle: AppTextStyle.font25,
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.borderGreyColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)))),
                  length: 6,
                ),
                if (state.timer == 0) const AppHeight(height: 30),
                if (state.timer == 0)
                  GestureDetector(
                      onTap: () {
                        context.read<OtpBloc>().add(ResendCode(
                            resendToken: widget.resendToken,
                            verificationId: widget.verificationID,
                            phoneNumber: widget.phoneNumber,
                            context: context));
                      },
                      child: Text(AppLocalizations.of(context)!.sendAgain,
                          style: AppTextStyle.font20
                              .copyWith(color: AppColors.redColor))),
                const AppHeight(height: 30),
                CustomNewButton(
                    btnName: AppLocalizations.of(context)!.verify,
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;
                      context.read<OtpBloc>().add(VerifyOtp(
                          context: context,
                          phoneNumber: widget.phoneNumber,
                          verificationId: widget.verificationID,
                          otpController: _otpController));
                    })
              ],
            );
          }),
        ),
      ),
    );
  }
}
