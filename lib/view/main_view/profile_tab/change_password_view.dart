import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';

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
                                'Change password',
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
                          if((value??"").isEmpty){
                            return "Old Password is req";
                          }
                          if((value??"").length < 8){
                            return "Password must be 8";
                          }
                          if((value??"") == _newPasswordController.text){
                            return "Your new password cannot be the same as your old password. Please choose a different";
                          }
                          return null;
                        },
                      hintText: "Enter old password",
                      textEditingController: _oldPasswordController),
                  const SizedBox(height: 20),
                  CustomTextField(
                        errorMaxLines: 2,
                      validator: (value) {
                          if((value??"").isEmpty){
                            return "New Password is req";
                          }
                          if((value??"").length < 8){
                            return "Password must be 8";
                          }
                          if((value??"") == _oldPasswordController.text){
                            return "Your new password cannot be the same as your old password. Please choose a different";
                          }
                          return null;
                        },
                      hintText: "Enter new password",
                      textEditingController: _newPasswordController),
                  const SizedBox(height: 20),
                  CustomTextField(
                    errorMaxLines: 2,
                    validator: (value) {
                          if((value??"").isEmpty){
                            return "Confirm Password is req";
                          }
                          if((value??"").length < 8){
                            return "Password must be 8";
                          }
                          if((value??"") != _newPasswordController.text){
                            return "The confirmation message does not match. Please try again.";
                          }
                          return null;
                        },
                      hintText: "Enter confirm password",
                      textEditingController: _confirmpasswordController),
                  const Spacer(),
                  CustomNewButton(
                    btnName: 'Update Password',
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
            message: "Password updated successfully!",
            title: "Congrats!");
      } else {
         LoadingDialog.hideProgress(context);
        showOkAlertDialog(
            context: context,
            message: "User not logged in",
            title: "Error");
      }
    } catch (error) {
         LoadingDialog.hideProgress(context);
      showOkAlertDialog(
          context: context, message: error.toString(), title: "Error");
    }
  }
}