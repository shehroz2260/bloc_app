import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteColor,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Column(
              children: [
                const AppHeight(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(),
                    Text(
                      AppLocalizations.of(context)!.changePassword,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                          fontSize: 30),
                    ),
                    const SizedBox(width: 50),
                  ],
                ),
                const AppHeight(height: 20),
                CustomTextField(
                    errorMaxLines: 2,
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return AppLocalizations.of(context)!.oldPasswordIsReq;
                      }
                      if ((value ?? "").length < 8) {
                        return AppLocalizations.of(context)!.passwordMustbe8;
                      }
                      if ((value ?? "") == _newPasswordController.text) {
                        return AppLocalizations.of(context)!
                            .yourNewPasswordCannotBeTheSame;
                      }
                      return null;
                    },
                    hintText: AppLocalizations.of(context)!.enterOldPassword,
                    textEditingController: _oldPasswordController),
                const SizedBox(height: 20),
                CustomTextField(
                    errorMaxLines: 2,
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return AppLocalizations.of(context)!.newPasswordIsReq;
                      }
                      if ((value ?? "").length < 8) {
                        return AppLocalizations.of(context)!.passwordMustbe8;
                      }
                      if ((value ?? "") == _oldPasswordController.text) {
                        return AppLocalizations.of(context)!
                            .yourNewPasswordCannotBeTheSame;
                      }
                      return null;
                    },
                    hintText: AppLocalizations.of(context)!.enterNewPassword,
                    textEditingController: _newPasswordController),
                const SizedBox(height: 20),
                CustomTextField(
                    errorMaxLines: 2,
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return AppLocalizations.of(context)!
                            .confirmPasswordIsReq;
                      }
                      if ((value ?? "").length < 8) {
                        return AppLocalizations.of(context)!.passwordMustbe8;
                      }
                      if ((value ?? "") != _newPasswordController.text) {
                        return AppLocalizations.of(context)!
                            .theConfirmationMessageDoesNotMatch;
                      }
                      return null;
                    },
                    hintText:
                        AppLocalizations.of(context)!.enterConfirmPassword,
                    textEditingController: _confirmpasswordController),
                const Spacer(),
                CustomNewButton(
                  btnName: AppLocalizations.of(context)!.updatePassword,
                  onTap: _updatePassword,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    LoadingDialog.showProgress(context);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _oldPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(_newPasswordController.text);
        LoadingDialog.hideProgress(context);
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmpasswordController.clear();
        showOkAlertDialog(
            context: context,
            message: AppLocalizations.of(context)!.passwordUpdatedSuccessfully,
            title: AppLocalizations.of(context)!.congrats);
      } else {
        LoadingDialog.hideProgress(context);
        showOkAlertDialog(
            context: context, message: "User not logged in", title: "Error");
      }
    } catch (error) {
      LoadingDialog.hideProgress(context);
      showOkAlertDialog(
          context: context, message: error.toString(), title: "Error");
    }
  }
}
