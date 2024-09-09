import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/app_validation.dart';
import 'package:chat_with_bloc/view_model/sign_up_bloc/sign_up_bloc.dart';
import 'package:chat_with_bloc/view_model/sign_up_bloc/sign_up_event.dart';
import 'package:chat_with_bloc/view_model/sign_up_bloc/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        backgroundColor: AppColors.blackColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const AppHeight(height: 50),
              Text(AppStrings.signup, style: AppTextStyle.font25),
              const AppHeight(height: 30),
              BlocBuilder<SignUpBloc, SignUpState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => context
                            .read<SignUpBloc>()
                            .add(ImagePickerEvent(context: context)),
                        child: Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.whiteColor),
                              shape: BoxShape.circle),
                          child:state.image != null? ClipRRect(
                            borderRadius: BorderRadius.circular(110),
                            child: Image.file(state.image!,fit: BoxFit.cover,)):Icon(Icons.add, color: AppColors.whiteColor),
                        ),
                      ),
                      if(state.borderClr == Colors.red) 
                      Text("Profile is required",style: AppTextStyle.font16.copyWith(color: Colors.red,fontSize: 12),)
                    ],
                  );
                },
              ),
              const AppHeight(height: 20),
               CustomTextField(
                validator: AppValidation.nameValidation,
                textEditingController: _nameController,
                hintText: AppStrings.enterYourName,
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
               CustomButton(btnName: AppStrings.signup,onTap: _onSignUp),
              const AppHeight(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.alreadyHaveAnAccount,
                      style: AppTextStyle.font20),
                  GestureDetector(
                      onTap: () => Go.back(context),
                      child: Text(AppStrings.signIn,
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

  _onSignUp(){
  context.read<SignUpBloc>().add(OnSignUpEvent(context: context, formKey: _formKey, nameController: _nameController, emailController: _emailController, passwordController: _passwordController));
  }
}
