import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/main_view/main_view.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.appIcon),
            const AppHeight(height: 40),
            Text(
              AppLocalizations.of(context)!.congrats,
              style: AppTextStyle.font25.copyWith(color: theme.textColor),
            ),
            Text(
              AppLocalizations.of(context)!.youareallsetyourprofile,
              style: AppTextStyle.font20.copyWith(color: theme.textColor),
            ),
            const AppHeight(height: 40),
            Text(
              AppLocalizations.of(context)!.nowYouAreReadyToExplorethepeople,
              style: AppTextStyle.font16.copyWith(color: theme.textColor),
              textAlign: TextAlign.center,
            ),
            const AppHeight(height: 40),
            CustomNewButton(
              btnName: AppLocalizations.of(context)!.getintoApp,
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
