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
import 'package:chat_with_bloc/view/main_view/profile_tab/faqs_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
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
import 'change_password_view.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
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
                    'Settings',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackColor,
                        fontSize: 30),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
              const AppHeight(height: 20),
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
                            child: Text("See Profile",
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
                color: Colors.amber,
                icon: Icons.info,
                onTap: () {
                  Go.to(context, const AboutUsView());
                },
                title: "About us",
              ),
              if (signinMethod == "password")
                SettiingWidget(
                  color: Colors.blue,
                  icon: Icons.lock_open_outlined,
                  onTap: () {
                    Go.to(context, const ChangePasswordView());
                  },
                  title: "Change password",
                ),
              SettiingWidget(
                color: Colors.green,
                icon: Icons.message,
                onTap: () {},
                title: "Contact us",
              ),
              SettiingWidget(
                color: Colors.purple,
                icon: Icons.policy,
                onTap: () {},
                title: "Terms & Conditions",
              ),
              SettiingWidget(
                color: Colors.orange,
                icon: Icons.help_outline,
                onTap: () {
                  Go.to(context, const FaqsView());
                },
                title: "FAQs",
              ),
              SettiingWidget(
                color: Colors.red,
                icon: Icons.delete_forever,
                onTap: () async {
                  var res = await showOkCancelAlertDialog(
                      context: context,
                      message:
                          "Do you really want to delete your account, This action is permanent and cannot be undo.",
                      title: "Are you sure!");
                  if (res == OkCancelResult.cancel) return;
                  _deleteAccount(context);
                },
                title: "Delete Account",
              ),
              SettiingWidget(
                color: Colors.pinkAccent.shade100,
                icon: Icons.logout_outlined,
                onTap: () async {
                  var result = await showOkCancelAlertDialog(
                      context: context,
                      message: "Do you really want to logout",
                      title: "Are you sure!",
                      okLabel: "Yes",
                      cancelLabel: "Not now");
                  if (result == OkCancelResult.cancel) return;
                  await FirebaseAuth.instance.signOut();
                  context
                      .read<UserBaseBloc>()
                      .add(UpdateUserEvent(userModel: UserModel.emptyModel));
                  context.read<MainBloc>().add(ChangeIndexEvent(index: 0));
                  Go.offAll(context, const SplashView());
                },
                title: "Logout",
              ),
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
                hintText: "Enter password",
                validator: AppValidation.passwordValidation,
                textEditingController: passwordController,
              ),
            ),
            title: const Text("Please enter password for confirmation"),
            actions: [
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
                    "Confirm",
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
      if (e.code == ErrorStrings.invalidPhoneNumber) {
        showOkAlertDialog(
            context: context,
            message: ErrorStrings.theProvidedPhoneNumberIsNotValid,
            title: "Error");
        return;
      }
      if (e.code == ErrorStrings.tooManyRequests) {
        showOkAlertDialog(
            context: context,
            message:
                ErrorStrings.youHaveAttemptedTooManyRequestsPleaseTryAgainLater,
            title: ErrorStrings.smsVerificationError);
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
          title: const Text("Please enter the otp for confirmation"),
          actions: [
            MaterialButton(
              onPressed: () async {
                if (otpController.text.length != 6) {
                  showOkAlertDialog(
                      context: context,
                      message: "Please enter valid otp",
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
                  "Confirm",
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
  const SettiingWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
                    style: AppTextStyle.font20
                        .copyWith(color: AppColors.blackColor))),
            const Icon(Icons.arrow_forward_ios_outlined)
          ],
        ),
      ),
    );
  }
}
