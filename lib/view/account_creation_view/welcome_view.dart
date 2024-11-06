import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/main_view/main_view.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.appIcon),
            const AppHeight(height: 40),
            Text(
              "Congrats!",
              style: AppTextStyle.font25.copyWith(color: AppColors.blackColor),
            ),
            Text(
              "You are all set your profile",
              style: AppTextStyle.font20.copyWith(color: AppColors.blackColor),
            ),
            const AppHeight(height: 40),
            Text(
              "Now you are ready to explore the peoples and make match with your perfect partener",
              style: AppTextStyle.font16.copyWith(color: AppColors.blackColor),
              textAlign: TextAlign.center,
            ),
            const AppHeight(height: 40),
            CustomNewButton(
              btnName: "Get into App",
              onTap: () {
                Go.offAll(context, const MainView());
              },
            ),
            const AppHeight(height: 20)
          ],
        ),
      ),
    );
  }
}
