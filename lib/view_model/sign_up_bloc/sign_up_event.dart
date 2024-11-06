// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class SignUpEvent {}

class OnSignUpEvent extends SignUpEvent {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  OnSignUpEvent({
    required this.context,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });
}
