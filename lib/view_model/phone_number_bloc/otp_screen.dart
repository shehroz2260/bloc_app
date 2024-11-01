import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  final String verificationID;
  final String phoneNumber;
  final int resendToken;
  const OtpScreen({super.key, required this.verificationID, required this.phoneNumber, required this.resendToken});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}