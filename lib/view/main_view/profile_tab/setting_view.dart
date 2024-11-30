import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/main_view/match_tab/user_profile_view/user_profile_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/about_us_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/change_theme_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/contact_us_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/faqs_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/story_view.dart';
import 'package:chat_with_bloc/view_model/change_theme_bloc/change_theme_bloc.dart';
import 'package:chat_with_bloc/view_model/change_theme_bloc/change_theme_state.dart';
import 'package:chat_with_bloc/view_model/setting_bloc/setting_bloc.dart';
import 'package:chat_with_bloc/view_model/setting_bloc/setting_event.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/delete_account_dialogs.dart';
import 'package:chat_with_bloc/widgets/image_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/user_model.dart';
import '../../../src/go_file.dart';
import '../../../view_model/main_bloc/main_bloc.dart';
import '../../../view_model/main_bloc/main_event.dart';
import '../../../view_model/user_base_bloc/user_base_bloc.dart';
import '../../../view_model/user_base_bloc/user_base_event.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/setting_widget.dart';
import '../../splash_view/splash_view.dart';
import 'change_language_view.dart';
import 'change_password_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  void initState() {
    context.read<SettingBloc>().add(OninitSetting(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Padding(
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
                    AppLocalizations.of(context)!.settings,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: theme.textColor,
                        fontSize: 30),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
              const AppHeight(height: 20),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<UserBaseBloc, UserBaseState>(
                        builder: (context, userState) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.borderColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            AppCacheImage(
                                imageUrl: userState.userData.profileImage,
                                height: 60,
                                onTap: () {
                                  Go.to(
                                      context,
                                      ImageView(
                                          imageUrl:
                                              userState.userData.profileImage));
                                },
                                width: 60,
                                round: 60),
                            const AppWidth(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userState.userData.firstName,
                                  style: AppTextStyle.font20.copyWith(
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w700),
                                ),
                                const AppHeight(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    Go.to(
                                        context,
                                        UserProfileView(
                                          user: userState.userData,
                                          isCUser: true,
                                        ));
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.seeProfile,
                                      style: AppTextStyle.font16.copyWith(
                                        color: AppColors.blueColor,
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
                    const AppHeight(height: 20),
                    if (!context.read<UserBaseBloc>().state.userData.isAdmin)
                      SettiingWidget(
                        color: Colors.teal.shade300,
                        icon: Icons.camera_alt,
                        onTap: () {
                          Go.to(context, const StoryView());
                        },
                        title: AppLocalizations.of(context)!.story,
                      ),
                    SettiingWidget(
                      color: Colors.brown.shade400,
                      icon: Icons.language_sharp,
                      onTap: () {
                        Go.to(context, const ChangeLanguageView());
                      },
                      title: AppLocalizations.of(context)!.changeLanguage,
                    ),
                    BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
                        builder: (context, state) {
                      return SettiingWidget(
                        color: Colors.lightBlueAccent.shade100,
                        icon: state.currentTheme == ThemeMode.dark
                            ? Icons.dark_mode
                            : Icons.light_mode_rounded,
                        onTap: () {
                          Go.to(context, const ChangeThemeView());
                        },
                        title: AppLocalizations.of(context)!.changeTheme,
                      );
                    }),
                    if (!context.read<UserBaseBloc>().state.userData.isAdmin)
                      SettiingWidget(
                        color: Colors.purpleAccent.shade200,
                        icon: Icons.notifications,
                        isNotification: true,
                        onTap: () {
                          Go.to(context, const AboutUsView());
                        },
                        title: AppLocalizations.of(context)!.notification,
                      ),
                    if (!context.read<UserBaseBloc>().state.userData.isAdmin)
                      SettiingWidget(
                        color: Colors.amber.shade400,
                        icon: Icons.info,
                        onTap: () {
                          Go.to(context, const AboutUsView());
                        },
                        title: AppLocalizations.of(context)!.aboutUs,
                      ),
                    if (DeleteAccountDialogs.signinMethod == "password")
                      SettiingWidget(
                        color: Colors.blue,
                        icon: Icons.lock_open_outlined,
                        onTap: () {
                          Go.to(context, const ChangePasswordView());
                        },
                        title: AppLocalizations.of(context)!.changePassword,
                      ),
                    if (!context.read<UserBaseBloc>().state.userData.isAdmin)
                      SettiingWidget(
                        color: Colors.green,
                        icon: Icons.message,
                        onTap: () {
                          Go.to(context, const ContactUsView());
                        },
                        title: AppLocalizations.of(context)!.contactUs,
                      ),
                    if (!context.read<UserBaseBloc>().state.userData.isAdmin)
                      SettiingWidget(
                        color: Colors.purple,
                        icon: Icons.policy,
                        onTap: () {},
                        title: AppLocalizations.of(context)!.tAc,
                      ),
                    if (!context.read<UserBaseBloc>().state.userData.isAdmin)
                      SettiingWidget(
                        color: Colors.orange,
                        icon: Icons.help_outline,
                        onTap: () {
                          Go.to(context, const FaqsView());
                        },
                        title: AppLocalizations.of(context)!.faqs,
                      ),
                    SettiingWidget(
                      color: Colors.red,
                      icon: Icons.delete_forever,
                      onTap: () async {
                        var res = await showOkCancelAlertDialog(
                            context: context,
                            message: AppLocalizations.of(context)!
                                .doYouReallyWantToDeleteYourAccount,
                            title: AppLocalizations.of(context)!.areYouSure);
                        if (res == OkCancelResult.cancel) return;
                        DeleteAccountDialogs.deleteAccount(context);
                      },
                      title: AppLocalizations.of(context)!.deleteAccount,
                    ),
                    SettiingWidget(
                      color: Colors.pinkAccent.shade100,
                      icon: Icons.logout_outlined,
                      onTap: () async {
                        var result = await showOkCancelAlertDialog(
                            context: context,
                            message: AppLocalizations.of(context)!
                                .doYouReallyWantToLogout,
                            title: AppLocalizations.of(context)!.areYouSure,
                            okLabel: AppLocalizations.of(context)!.yes,
                            cancelLabel: AppLocalizations.of(context)!.notNow);
                        if (result == OkCancelResult.cancel) return;
                        await FirebaseAuth.instance.signOut();
                        context.read<UserBaseBloc>().add(
                            UpdateUserEvent(userModel: UserModel.emptyModel));
                        context
                            .read<MainBloc>()
                            .add(ChangeIndexEvent(index: 0));
                        Go.offAll(context, const SplashView());
                      },
                      title: AppLocalizations.of(context)!.logout,
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
