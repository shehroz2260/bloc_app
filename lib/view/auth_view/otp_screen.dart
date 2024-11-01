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

class OtpScreen extends StatefulWidget {
  final String verificationID;
  final String phoneNumber;
  final int resendToken;
  const OtpScreen({super.key, required this.verificationID, required this.phoneNumber, required this.resendToken});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _formKey  = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: BlocBuilder<OtpBloc, OtpState>(
            builder: (context,state) {
              return Column(
                children: [
                  const AppHeight(height: 70),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBackButton()),
                  const AppHeight(height: 30),
                   Text("00:59",style: AppTextStyle.font30.copyWith(color: AppColors.blackColor)),
                   Text("Type the verification code we’ve sent you",style: AppTextStyle.font16.copyWith(color: AppColors.blackColor)),
                  const AppHeight(height: 30),
                  Pinput(
                         validator: (value) {
                           if((value??"").isEmpty){
                            return "Enter pin";
                           }
                           if((value??"").length < 6){
                            return "Enter valid pin";
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
                                        border: Border.all(
                                            color: AppColors.redColor, width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)))),
                                focusedPinTheme: PinTheme(
                                    textStyle: AppTextStyle.font25,
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        border: Border.all(
                                            color: AppColors.redColor, width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)))),
                                defaultPinTheme: PinTheme(
                                    textStyle: AppTextStyle.font25,
                                    height: 50,
                                    width: 50,
                    
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.borderGreyColor,
                                            width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)))),
                                length: 6,
                              ),
                              if(state.timer == 0)
                              const AppHeight(height: 30),
                              if(state.timer == 0)
                              Text("Send again",style: AppTextStyle.font20.copyWith(color: AppColors.redColor)),
                              const AppHeight(height: 30),
                              CustomNewButton(btnName: "Verify",onTap: () {
                                if(!_formKey.currentState!.validate())return;
                                context.read<OtpBloc>().add(VerifyOtp(context: context, phoneNumber: widget.phoneNumber, verificationId: widget.verificationID, otpController: _otpController));
                              })
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}