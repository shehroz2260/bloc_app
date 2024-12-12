import 'dart:io';
import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/auth_view/sign_in_view.dart';
import 'package:chat_with_bloc/view_model/sign_in_bloc/sign_in_bloc.dart';
import 'package:chat_with_bloc/view_model/sign_in_bloc/sign_in_event.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../auth_view/phone_number_login_view.dart';

class SignOptionsView extends StatelessWidget {
  const SignOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
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
            const AppHeight(height: 50),
            SvgPicture.asset(AppAssets.appIcon),
            const AppHeight(height: 80),
            Text(AppLocalizations.of(context)!.signInToContinue,
                style: AppTextStyle.font20.copyWith(
                    color: theme.textColor, fontWeight: FontWeight.bold)),
            const AppHeight(height: 30),
            CustomNewButton(
                btnName: AppLocalizations.of(context)!.continueToEmail,
                onTap: () => Go.to(context, const SignInWithEmailView())),
            const AppHeight(height: 20),
            CustomNewButton(
              btnName: AppLocalizations.of(context)!.usePhoneNumber,
              isFillColor: false,
              onTap: () {
                Go.to(context, const PhoneNumberLoginView());
              },
            ),
            const AppHeight(height: 70),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  height: 0,
                  color: theme.textColor,
                  endIndent: 15,
                  indent: 15,
                )),
                Text(
                  AppLocalizations.of(context)!.or,
                  style: TextStyle(color: theme.textColor),
                ),
                Expanded(
                    child: Divider(
                  indent: 15,
                  endIndent: 15,
                  height: 0,
                  color: theme.textColor,
                ))
              ],
            ),
            const AppHeight(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomSigninBtnWithSocial(icon: AppAssets.facebookIcon),
                const AppWidth(width: 20),
                CustomSigninBtnWithSocial(
                  onTap: () {
                    context
                        .read<SignInBloc>()
                        .add(OnGooglesignin(context: context));
                  },
                ),
                if (Platform.isIOS) const AppWidth(width: 20),
                if (Platform.isIOS)
                  const CustomSigninBtnWithSocial(isApple: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
