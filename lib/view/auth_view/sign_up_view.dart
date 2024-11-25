import 'package:chat_with_bloc/src/app_colors.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final theme = AppTheme.of(context);
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.bgColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const AppHeight(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: SafeArea(child: CustomBackButton()),
              ),
              const AppHeight(height: 40),
              SvgPicture.asset(AppAssets.appIcon),
              const AppHeight(height: 20),
              Text(AppLocalizations.of(context)!.createAnAccoun,
                  style: AppTextStyle.font25.copyWith(color: theme.textColor)),
              const AppHeight(height: 30),
              CustomTextField(
                validator: (val) =>
                    AppValidation.userNameValidation(val, context),
                textEditingController: _nameController,
                hintText: AppLocalizations.of(context)!.enterUserName,
              ),
              const AppHeight(height: 20),
              CustomTextField(
                validator: (val) => AppValidation.emailValidation(val, context),
                textEditingController: _emailController,
                hintText: AppLocalizations.of(context)!.enterEmailAddress,
              ),
              const AppHeight(height: 20),
              CustomTextField(
                validator: (val) =>
                    AppValidation.passwordValidation(val, context),
                textEditingController: _passwordController,
                hintText: AppLocalizations.of(context)!.enterPassword,
                isPasswordField: true,
              ),
              const AppHeight(height: 20),
              CustomNewButton(
                  btnName: AppLocalizations.of(context)!.signup,
                  onTap: _onSignUp),
            ],
          ),
        ),
      ),
    );
  }

  _onSignUp() {
    context.read<SignUpBloc>().add(OnSignUpEvent(
        context: context,
        formKey: _formKey,
        nameController: _nameController,
        emailController: _emailController,
        passwordController: _passwordController));
  }
}
