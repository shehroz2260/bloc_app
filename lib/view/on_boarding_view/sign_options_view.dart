import 'dart:io';
import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/auth_view/sign_in_view.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignOptionsView extends StatelessWidget {
  const SignOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: SafeArea(child: CustomBackButton()),
            ),
            const AppHeight(height: 50),
            SvgPicture.asset(AppAssets.appIcon),
            const AppHeight(height: 80),
             Text(AppStrings.signInToContinue,style: AppTextStyle.font20.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold)),
            const AppHeight(height: 30),
             CustomNewButton(btnName: AppStrings.continueToEmail,onTap: () => Go.to(context,const SignInWithEmailView())),
            const AppHeight(height: 20),
            const CustomNewButton(btnName: AppStrings.usePhoneNumber,isFillColor: false),
            const AppHeight(height: 70),
            Row(
              children: [
                Expanded(child: Divider(height: 0,color: AppColors.blackColor,endIndent: 15,indent: 15,)),const Text(AppStrings.or),Expanded(child: Divider(indent: 15,endIndent: 15, height: 0,color: AppColors.blackColor,))
              ],
            ),
            const AppHeight(height: 30),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomSigninBtnWithSocial(icon: AppAssets.facebookIcon),
                const AppWidth(width: 20),
                const CustomSigninBtnWithSocial(),
                if(Platform.isIOS) const AppWidth(width: 20),
                if(Platform.isIOS)
                const CustomSigninBtnWithSocial(isApple: true),
              ],
            ),
            const AppHeight(height: 20),

          ],
        ),
      ),
    );
  }
}
