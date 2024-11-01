// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class OtpEvent {}

class ScheduleTimer extends OtpEvent {}

class VerifyOtp extends OtpEvent {
  final BuildContext context;
  final String phoneNumber;
  final String verificationId;
  final TextEditingController otpController;
  VerifyOtp({
    required this.context,
    required this.phoneNumber,
    required this.verificationId,
    required this.otpController,
  });
}
