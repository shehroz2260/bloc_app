import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/char_model.dart';
import '../model/filter_model.dart';
import '../model/thread_model.dart';
import '../model/user_model.dart';
import '../services/firebase_services_storage.dart';
import '../src/app_colors.dart';
import '../src/app_string.dart';
import '../src/go_file.dart';
import '../utils/app_validation.dart';
import '../utils/loading_dialog.dart';
import '../view/splash_view/splash_view.dart';
import '../view_model/main_bloc/main_bloc.dart';
import '../view_model/main_bloc/main_event.dart';
import '../view_model/user_base_bloc/user_base_bloc.dart';
import '../view_model/user_base_bloc/user_base_event.dart';

class DeleteAccountDialogs {
  static void deleteAccount(BuildContext context) async {
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

  static Future<void> gmailAccountDelete(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    user!.reauthenticateWithCredential(credential).then((value) async {
      await deleteUserData(context);
    });
  }

  static Future<void> emailPassword(BuildContext context) async {
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3))),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3))),
                    height: 30,
                    width: 70,
                    child: Text(
                      AppLocalizations.of(context)!.confirm,
                      style:
                          TextStyle(color: AppColors.whiteColor, fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  static Future<void> phoneNumberAccountDelete(BuildContext context) async {
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

  static String get signinMethod {
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

  static Future<void> deleteUserData(BuildContext context) async {
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
}
