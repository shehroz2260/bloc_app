// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

abstract class PhoneNumberEvent {}

class OnCountryCodeChange extends PhoneNumberEvent {
  final CountryCode code;
  final BuildContext context;
  OnCountryCodeChange({
    required this.code,
    required this.context,
  });
}

class VerifyPhoneNumber extends PhoneNumberEvent {
  final BuildContext context;
  final TextEditingController controller;
  VerifyPhoneNumber({
    required this.context,
    required this.controller,
  });
}
