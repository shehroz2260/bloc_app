import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/app_validation.dart';
import 'package:chat_with_bloc/view_model/sign_in_bloc/sign_in_bloc.dart';
import 'package:chat_with_bloc/view_model/sign_in_bloc/sign_in_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../src/app_assets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInWithEmailView extends StatefulWidget {
  const SignInWithEmailView({super.key});

  @override
  State<SignInWithEmailView> createState() => _SignInWithEmailViewState();
}

class _SignInWithEmailViewState extends State<SignInWithEmailView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Align(
              alignment: Alignment.centerLeft,
              child: SafeArea(child: CustomBackButton()),
            ),
            const AppHeight(height: 40),
            SvgPicture.asset(AppAssets.appIcon),
              const AppHeight(height: 20),
              Text(AppStrings.signInWithEmail, style: AppTextStyle.font25.copyWith(color: AppColors.blackColor)),
              const AppHeight(height: 30),
              CustomTextField(
                textEditingController: _emailController,
                validator: AppValidation.emailValidation,
                hintText: AppStrings.enterEmailAddress,
              ),
              const AppHeight(height: 20),
              CustomTextField(
                textEditingController: _passwordController,
                validator: AppValidation.passwordValidation,
                hintText: AppStrings.enterPassword,
                isPasswordField: true,
              ),
              const AppHeight(height: 20),
              CustomNewButton(btnName: AppStrings.signIn,onTap: _onSignin)
            
            ],
          ),
        ),
      ),
    );
  }

  _onSignin() {
    context.read<SignInBloc>().add(OnSigninEvent(
        context: context,
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController));
  }
}