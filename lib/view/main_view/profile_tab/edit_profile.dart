import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/app_validation.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../view_model/user_base_bloc/user_base_bloc.dart';
import '../../../view_model/user_base_bloc/user_base_event.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _formKey = GlobalKey<FormState>();
Future<void> updateEmail(String newEmail) async {
  if(!_formKey.currentState!.validate()) return;
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _passwordController.text,
      );
    await  user.reauthenticateWithCredential(credential);
      await user.verifyBeforeUpdateEmail(newEmail);
      var cUser = context.read<UserBaseBloc>().state.userData;
       cUser = cUser.copyWith(email: newEmail);
       await launchUrlString("mailto:");
     context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: cUser));
await FirebaseFirestore.instance.collection(UserModel.tableName).doc(user.uid).set(cUser.toMap(),SetOptions(merge: true));
      showOkAlertDialog(context: context , message: "Your email successfully updated");
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
         showOkAlertDialog(context: context , message: "dddddddddddddddddddd");
        // print("The user needs to reauthenticate before this operation.");
        // Handle reauthentication here
      } else {
         showOkAlertDialog(context: context , message: e.message);

        // print("Failed to update email: ${e.message}");
      }
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.blackColor,
        appBar: AppBar(
          backgroundColor: AppColors.blackColor,
          foregroundColor: AppColors.whiteColor,
          title: const Text("Update Email"),
          centerTitle: true,
        ),
        body:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeight(height: 50),
               Text("Old Password",style: TextStyle(
                color: AppColors.whiteColor
              ),),
              const AppHeight(height: 5),
              CustomTextField(
                validator: AppValidation.passwordValidation,
                hintText: "Password",textEditingController: _passwordController,),
              const AppHeight(height: 25),
               Text("New email",style: TextStyle(
                color: AppColors.whiteColor
              ),),
              const AppHeight(height: 5),
              CustomTextField(
                validator: AppValidation.emailValidation,
                hintText: "Email",textEditingController: _emailController,),
              const AppHeight(height: 25),
              CustomButton(btnName: "Update",onTap: ()async{
          await updateEmail(_emailController.text);
              })
            ],
          ),
        ),
      ),
    );
  }
}