import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/filter_model.dart';
import 'package:chat_with_bloc/services/firebase_services_storage.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/app_validation.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view/main_view/match_tab/user_profile_view/user_profile_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/about_us_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/change_theme_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/faqs_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/story_view.dart';
import 'package:chat_with_bloc/view_model/change_theme_bloc/change_theme_bloc.dart';
import 'package:chat_with_bloc/view_model/change_theme_bloc/change_theme_state.dart';
import 'package:chat_with_bloc/view_model/setting_bloc/setting_bloc.dart';
import 'package:chat_with_bloc/view_model/setting_bloc/setting_event.dart';
import 'package:chat_with_bloc/view_model/setting_bloc/setting_state.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:chat_with_bloc/widgets/image_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pinput.dart';
import '../../../model/char_model.dart';
import '../../../model/thread_model.dart';
import '../../../model/user_model.dart';
import '../../../src/go_file.dart';
import '../../../view_model/main_bloc/main_bloc.dart';
import '../../../view_model/main_bloc/main_event.dart';
import '../../../view_model/user_base_bloc/user_base_bloc.dart';
import '../../../view_model/user_base_bloc/user_base_event.dart';
import '../../../widgets/custom_button.dart';
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
                    SettiingWidget(
                      color: Colors.purpleAccent.shade200,
                      icon: Icons.notifications,
                      isNotification: true,
                      onTap: () {
                        Go.to(context, const AboutUsView());
                      },
                      title: AppLocalizations.of(context)!.notification,
                    ),
                    SettiingWidget(
                      color: Colors.amber.shade400,
                      icon: Icons.info,
                      onTap: () {
                        Go.to(context, const AboutUsView());
                      },
                      title: AppLocalizations.of(context)!.aboutUs,
                    ),
                    if (signinMethod == "password")
                      SettiingWidget(
                        color: Colors.blue,
                        icon: Icons.lock_open_outlined,
                        onTap: () {
                          Go.to(context, const ChangePasswordView());
                        },
                        title: AppLocalizations.of(context)!.changePassword,
                      ),
                    SettiingWidget(
                      color: Colors.green,
                      icon: Icons.message,
                      onTap: () {},
                      title: AppLocalizations.of(context)!.contactUs,
                    ),
                    SettiingWidget(
                      color: Colors.purple,
                      icon: Icons.policy,
                      onTap: () {},
                      title: AppLocalizations.of(context)!.tAc,
                    ),
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
                        _deleteAccount(context);
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

void _deleteAccount(BuildContext context) async {
  if (signinMethod == "google") {
    await gmailAccountDelete(context);
  }
  if (signinMethod == "phone") {
    await phoneNumberAccountDelete(context);
  }
  if (signinMethod == "password") {
    await emailPassword(context);
  }
}

Future<void> gmailAccountDelete(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  if (googleUser == null) return;
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  user!.reauthenticateWithCredential(credential).then((value) async {
    await deleteUserData(context);
  });
}

Future<void> emailPassword(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  if (user == null) return;

  showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            content: SizedBox(
              height: 60,
              child: CustomTextField(
                hintText: AppLocalizations.of(context)!.enterPassword,
                validator: (val) =>
                    AppValidation.passwordValidation(val, context),
                textEditingController: passwordController,
              ),
            ),
            title: Text(AppLocalizations.of(context)!
                .pleaseEnterPasswordForConfirmation),
            actions: [
              MaterialButton(
                onPressed: () => Go.back(context),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.redColor.withOpacity(0.2),
                      border: Border.all(color: AppColors.borderGreyColor),
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                  height: 30,
                  width: 70,
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(color: AppColors.redColor, fontSize: 14),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  LoadingDialog.showProgress(context);
                  try {
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: user.email ?? "",
                      password: passwordController.text,
                    );
                    await user
                        .reauthenticateWithCredential(credential)
                        .then((value) async {
                      await deleteUserData(context);
                    });
                  } on FirebaseAuthException catch (e) {
                    LoadingDialog.hideProgress(context);
                    showOkAlertDialog(
                        context: context, message: e.message, title: "Error");
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.redColor,
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                  height: 30,
                  width: 70,
                  child: Text(
                    AppLocalizations.of(context)!.confirm,
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 14),
                  ),
                ),
              )
            ],
          ),
        );
      });
}

Future<void> phoneNumberAccountDelete(BuildContext context) async {
  String verificationIds = "";
  final otpController = TextEditingController();
  var user = FirebaseAuth.instance.currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  await auth.verifyPhoneNumber(
    timeout: const Duration(seconds: 60),
    phoneNumber: user!.phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {},
    verificationFailed: (FirebaseAuthException e) {
      LoadingDialog.hideProgress(context);
      if (e.code == AppStrings.invalidPhoneNumber) {
        showOkAlertDialog(
            context: context,
            message: AppStrings.theProvidedPhoneNumberIsNotValid,
            title: "Error");
        return;
      }
      if (e.code == AppStrings.tooManyRequests) {
        showOkAlertDialog(
            context: context,
            message:
                AppStrings.youHaveAttemptedTooManyRequestsPleaseTryAgainLater,
            title: AppStrings.smsVerificationError);
        return;
      }
    },
    codeSent: (String verificationId, int? resendToken) async {
      verificationIds = verificationId;
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 60,
            child: Pinput(
              controller: otpController,
              cursor: Container(
                height: 20,
                width: 2,
                color: AppColors.redColor,
              ),
              defaultPinTheme: PinTheme(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: AppColors.redColor,
                  ),
                  height: 60,
                  width: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.redColor, width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(3)))),
              length: 6,
            ),
          ),
          title: Text(
              AppLocalizations.of(context)!.pleaseEnterTheOtpForConfirmation),
          actions: [
            MaterialButton(
              onPressed: () async {
                if (otpController.text.length != 6) {
                  showOkAlertDialog(
                      context: context,
                      message:
                          AppLocalizations.of(context)!.pleaseEntervalidttp,
                      title: "Error");
                  return;
                }
                LoadingDialog.showProgress(context);
                AuthCredential authCredential = PhoneAuthProvider.credential(
                    verificationId: verificationIds,
                    smsCode: otpController.text);
                try {
                  await user
                      .reauthenticateWithCredential(authCredential)
                      .then((value) async {
                    await deleteUserData(context);
                  });
                } on FirebaseAuthException {
                  LoadingDialog.hideProgress(context);
                  showOkAlertDialog(
                      context: context,
                      message: "Verifiction code is invalid",
                      title: "Error");
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.redColor,
                    borderRadius: const BorderRadius.all(Radius.circular(3))),
                height: 30,
                width: 70,
                child: Text(
                  AppLocalizations.of(context)!.confirm,
                  style: TextStyle(color: AppColors.whiteColor, fontSize: 14),
                ),
              ),
            )
          ],
        );
      });
}

String get signinMethod {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    for (UserInfo userInfo in user.providerData) {
      switch (userInfo.providerId) {
        case 'password':
          return 'password';
        case 'google.com':
          return 'google';
        case 'apple.com':
          return 'apple';
        case 'phone':
          return 'phone';
        default:
          return 'Signed in with ${userInfo.providerId}';
      }
    }
  }
  return "not signed in";
}

Future<void> deleteUserData(BuildContext context) async {
  final user = context.read<UserBaseBloc>().state.userData;
  final cUSer = FirebaseAuth.instance.currentUser;
  if (cUSer == null) return;
  await FirebaseFirestore.instance
      .collection(ThreadModel.tableName)
      .where("participantUserList", arrayContains: user.uid)
      .get()
      .then((value) {
    if (value.docs.isNotEmpty) {
      for (final e in value.docs) {
        final model = ThreadModel.fromMap(e.data());
        FirebaseFirestore.instance
            .collection(ThreadModel.tableName)
            .doc(model.threadId)
            .collection(ChatModel.tableName)
            .get()
            .then((valuess) {
          if (valuess.docs.isNotEmpty) {
            for (final db in valuess.docs) {
              final chatModel = ChatModel.fromMap(db.data());
              if (chatModel.media != null) {
                FirebaseStorageService()
                    .deleteFile(chatModel.media?.url ?? "", context);
              }

              db.reference.delete();
            }
          }
        });
        e.reference.delete();
      }
    }
  });

  for (final match in user.matches) {
    await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(match)
        .get()
        .then((value) {
      if (value.exists) {
        final model = UserModel.fromMap(value.data()!);
        FirebaseFirestore.instance
            .collection(UserModel.tableName)
            .doc(model.uid)
            .update({
          "otherLikes": FieldValue.arrayRemove([user.uid]),
          "myLikes": FieldValue.arrayRemove([user.uid]),
          "otherDislikes": FieldValue.arrayRemove([user.uid]),
          "matches": FieldValue.arrayRemove([user.uid]),
          "myDislikes": FieldValue.arrayRemove([user.uid]),
        });
      }
    });
  }

  if (user.profileImage.isNotEmpty) {
    await FirebaseStorageService().deleteFile(user.profileImage, context);
  }
  if (user.galleryImages.isNotEmpty) {
    for (final e in user.galleryImages) {
      await FirebaseStorageService().deleteFile(e, context);
    }
  }

  await FirebaseFirestore.instance
      .collection(FilterModel.tableName)
      .doc(user.uid)
      .delete();
  FirebaseFirestore.instance
      .collection(UserModel.tableName)
      .doc(user.uid)
      .delete();
  cUSer.delete();
  context
      .read<UserBaseBloc>()
      .add(UpdateUserEvent(userModel: UserModel.emptyModel));
  context.read<MainBloc>().add(ChangeIndexEvent(index: 0));
  LoadingDialog.hideProgress(context);
  Go.offAll(context, const SplashView());
}

class SettiingWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onTap;
  final Color color;
  final bool isNotification;
  const SettiingWidget({
    super.key,
    this.isNotification = false,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: AppColors.whiteColor),
            ),
            const AppWidth(width: 12),
            Expanded(
                child: Text(title,
                    style:
                        AppTextStyle.font20.copyWith(color: theme.textColor))),
            isNotification
                ? BlocBuilder<SettingBloc, SettingState>(
                    builder: (context, state) {
                    return Switch(
                        value: state.isOnNotification,
                        onChanged: (val) {
                          context.read<SettingBloc>().add(
                              OnNotificationEvent(isOn: val, context: context));
                        });
                  })
                : const Icon(Icons.arrow_forward_ios_outlined)
          ],
        ),
      ),
    );
  }
}
