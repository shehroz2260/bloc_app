import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/app_validation.dart';
import 'package:chat_with_bloc/view/auth_view/sign_up_view.dart';
import 'package:chat_with_bloc/view_model/sign_in_bloc/sign_in_bloc.dart';
import 'package:chat_with_bloc/view_model/sign_in_bloc/sign_in_event.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.blackColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const AppHeight(height: 50),
              Text(AppStrings.signIn, style: AppTextStyle.font25),
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
              CustomButton(
                btnName: AppStrings.signIn,
                onTap: _onSignin,
              ),
              const AppHeight(height: 20),
              Row(
                children: [
                  Expanded(
                      child: Divider(
                          color: AppColors.whiteColor,
                          height: 0,
                          endIndent: 10)),
                  Text(AppStrings.or, style: AppTextStyle.font16),
                  Expanded(
                      child: Divider(
                          color: AppColors.whiteColor,
                          height: 0,
                          indent: 10)),
                ],
              ),
              const AppHeight(height: 20),
              const CustomSigninBtnWithSocial(),
              const AppHeight(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.noAccount, style: AppTextStyle.font20),
                  GestureDetector(
                      onTap: () => Go.to(context, const SignUpView()),
                      child: Text(AppStrings.signup,
                          style: AppTextStyle.font20
                              .copyWith(color: AppColors.blueColor))),
                ],
              )
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
