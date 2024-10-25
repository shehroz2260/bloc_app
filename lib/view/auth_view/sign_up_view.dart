import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/app_validation.dart';
import 'package:chat_with_bloc/view_model/sign_up_bloc/sign_up_bloc.dart';
import 'package:chat_with_bloc/view_model/sign_up_bloc/sign_up_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../src/app_assets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _nameController = TextEditingController();
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
              Text(AppStrings.createAnAccoun, style: AppTextStyle.font25.copyWith(color: AppColors.blackColor)),
              const AppHeight(height: 30),
              
               CustomTextField(
                validator: AppValidation.userNameValidation,
                textEditingController: _nameController,
                hintText: AppStrings.enterUserName,
              ),
              const AppHeight(height: 20),
               CustomTextField(
                validator: AppValidation.emailValidation,
                textEditingController: _emailController,
                hintText: AppStrings.enterEmailAddress,
              ),
              const AppHeight(height: 20),
               CustomTextField(
                validator: AppValidation.passwordValidation,
                textEditingController: _passwordController,
                hintText: AppStrings.enterPassword,
                isPasswordField: true,
              ),
              const AppHeight(height: 20),
              CustomNewButton(btnName: AppStrings.signup,onTap: _onSignUp),
            ],
          ),
        ),
      ),
    );
  }

  _onSignUp(){
  context.read<SignUpBloc>().add(OnSignUpEvent(context: context, formKey: _formKey, nameController: _nameController, emailController: _emailController, passwordController: _passwordController));
  }
}
