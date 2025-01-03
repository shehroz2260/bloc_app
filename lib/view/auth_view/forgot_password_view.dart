import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../src/app_assets.dart';
import '../../src/app_colors.dart';
import '../../src/app_text_style.dart';
import '../../src/width_hieght.dart';
import '../../utils/app_validation.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.bgColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const AppHeight(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: SafeArea(child: CustomBackButton()),
              ),
              const AppHeight(height: 40),
              SvgPicture.asset(AppAssets.appIcon),
              const AppHeight(height: 20),
              Text(AppLocalizations.of(context)!.forgotPasswords,
                  style: AppTextStyle.font25.copyWith(color: theme.textColor)),
              const AppHeight(height: 30),
              CustomTextField(
                textEditingController: _emailController,
                validator: (val) => AppValidation.emailValidation(val, context),
                hintText: AppLocalizations.of(context)!.enterEmailAddress,
              ),
              const AppHeight(height: 20),
              CustomNewButton(
                  btnName: AppLocalizations.of(context)!.send,
                  onTap: _forgotPassword)
            ],
          ),
        ),
      ),
    );
  }

  _forgotPassword() {
    if (!_formKey.currentState!.validate()) return;
    LoadingDialog.showProgress(context);
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text)
        .then((value) async {
      LoadingDialog.hideProgress(context);
      await showOkAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.success,
          message:
              AppLocalizations.of(context)!.resetLinkHasBeenSentToYourEmail);
      Go.back(context);
    }).catchError((e) {
      LoadingDialog.hideProgress(context);
      showOkAlertDialog(
          context: context, title: "Error", message: e.toString());
    });
  }
}
