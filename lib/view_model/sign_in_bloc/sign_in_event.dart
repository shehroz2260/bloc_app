// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class SignInEvent {}

class OnSigninEvent extends SignInEvent {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  OnSigninEvent( {
    required this.formKey,
    required this.context,
    required this.emailController,
    required this.passwordController,
  });
}
