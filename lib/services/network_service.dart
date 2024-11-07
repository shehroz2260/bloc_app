import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/services/auth_services.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/app_funcs.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view/account_creation_view/bio_view.dart';
import 'package:chat_with_bloc/view/main_view/main_view.dart';
import 'package:chat_with_bloc/view/account_creation_view/dob_pick_view.dart';
import 'package:chat_with_bloc/view/account_creation_view/gender_view.dart';
import 'package:chat_with_bloc/view/account_creation_view/preference_view.dart';
import 'package:chat_with_bloc/view/on_boarding_view/on_boarding_screen.dart';
import 'package:chat_with_bloc/view/on_boarding_view/sign_options_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/char_model.dart';
import '../model/report_user_model.dart';
import '../model/thread_model.dart';
import '../view/account_creation_view/location_view.dart';
import '../view/main_view/home_tab/congrats_message_view.dart';
import '../view_model/user_base_bloc/user_base_state.dart';

class NetworkService {
  static Future<void> gotoHomeScreen(BuildContext context,
      [bool isSplash = false]) async {
    var isLoadData = await AuthServices.isLoadData(context);
    if (isSplash && !isLoadData) {
      Go.offAll(context, const OnBoardingScreen());
      return;
    }
    StreamSubscription<UserBaseState>? sub;
    sub = context.read<UserBaseBloc>().stream.listen((state) async {
      var user = state.userData;
      await sub?.cancel();
      if (user.dob == DateTime(1800) ||
          user.profileImage.isEmpty ||
          user.firstName.isEmpty) {
        if (isSplash) {
          await FirebaseAuth.instance.signOut();
          Go.offAll(context, const OnBoardingScreen());
        } else {
          Go.offAll(context, const DobPickView());
        }
        return;
      }
      if (user.gender == 0) {
        if (isSplash) {
          await FirebaseAuth.instance.signOut();
          Go.offAll(context, const OnBoardingScreen());
        } else {
          Go.offAll(context, const GenderView());
        }
        return;
      }
      if (user.preferGender == -1 || user.myInstrest.isEmpty) {
        if (isSplash) {
          await FirebaseAuth.instance.signOut();
          Go.offAll(context, const OnBoardingScreen());
        } else {
          Go.offAll(context, const PreferenceView());
        }
        return;
      }
      if (user.about.isEmpty || user.bio.isEmpty) {
        if (isSplash) {
          await FirebaseAuth.instance.signOut();
          Go.offAll(context, const OnBoardingScreen());
        } else {
          Go.offAll(context, const BioView());
        }
        return;
      }
      if ((!await Permission.location.isGranted) ||
          (!await Permission.locationWhenInUse.serviceStatus.isEnabled) ||
          (user.lat == 0.0 && user.lng == 0.0)) {
        if (isSplash) {
          FirebaseAuth.instance.signOut();
          Go.offAll(context, const SignOptionsView());
        } else {
          Go.offAll(context, const LocationPermissionScreen());
        }
        return;
      }
      Go.offAll(context, const MainView());
    });
  }

  static void updateUser(UserModel user) async {
    await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }

  static Future<void> likeUser(
      UserModel liker, UserModel likee, BuildContext context) async {
    bool isMatch = liker.otherLikes.contains(likee.uid);

    await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(liker.uid)
        .update({
      "myLikes": FieldValue.arrayUnion([likee.uid]),
      if (isMatch) "matches": FieldValue.arrayUnion([likee.uid]),
    });
    await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(likee.uid)
        .update({
      "otherLikes": FieldValue.arrayUnion([liker.uid]),
      if (isMatch) "matches": FieldValue.arrayUnion([liker.uid]),
    });
    var user = context.read<UserBaseBloc>().state.userData;
    context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
    if (isMatch) {
      await createNewThread(liker, likee, null);
      LoadingDialog.hideProgress(context);
      Go.to(context, CongratsMessageView(user: likee));
    }
  }

  static Future<void> createNewThread(
      UserModel liker, UserModel likee, String? message) async {
    var threadId = createThreadId(liker.uid, likee.uid);
    var snapShot = await FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .doc(threadId)
        .get();
    if (snapShot.exists) return;
    var thread = ThreadModel(
        lastMessage: message ?? "",
        lastMessageTime: DateTime.now(),
        participantUserList: [liker.uid, likee.uid],
        senderId: liker.uid,
        messageCount: 1,
        threadId: threadId,
        messageDelete: [],
        isPending: false,
        isBlocked: false,
        activeUserList: [],
        blockUserList: []);

    await FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .doc(threadId)
        .set({...thread.toMap(), "isPending": message == null ? false : true},
            SetOptions(merge: true));
    if (message == null) {
      return;
    }
    ChatModel chatModel = ChatModel(
      id: AppFuncs.generateRandomString(10),
      senderId: liker.uid,
      isRead: false,
      message: message,
      messageTime: DateTime.now(),
      threadId: threadId,
      media: null,
    );
    await FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .doc(threadId)
        .collection(ThreadModel.tableName)
        .doc(chatModel.id)
        .set(chatModel.toMap(), SetOptions(merge: true));
  }

  static Future<void> disLikeUser(UserModel liker, UserModel likee) async {
    await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(liker.uid)
        .set({
      "myLikes": FieldValue.arrayRemove([likee.uid]),
      "matches": FieldValue.arrayRemove([likee.uid]),
      "otherLikes": FieldValue.arrayRemove([likee.uid]),
      "myDisLikes": FieldValue.arrayUnion([likee.uid])
    }, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(likee.uid)
        .set({
      "otherLikes": FieldValue.arrayRemove([liker.uid]),
      "matches": FieldValue.arrayRemove([liker.uid]),
      "myLikes": FieldValue.arrayRemove([liker.uid]),
      "otherDislikes": FieldValue.arrayUnion([liker.uid])
    }, SetOptions(merge: true));
  }

  static Future<UserModel> getUserDetailById(String uid) {
    return FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(uid)
        .get()
        .then((value) => UserModel.fromMap(value.data() ?? {}));
  }

  static Future<void> blockUser(ThreadModel threadModel) async {
    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    await FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .doc(threadModel.threadId)
        .set({
      "isBlocked": true,
      "blockUserList": FieldValue.arrayUnion([uid]),
      "senderId": uid,
      "lastMessage": "Blocked",
      "lastMessageTime": Timestamp.now()
    }, SetOptions(merge: true));
  }

  static Future<void> unblockUser(ThreadModel threadModel) async {
    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    await FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .doc(threadModel.threadId)
        .set({
      "blockUserList": FieldValue.arrayRemove([uid]),
      "isBlocked": false,
      "senderId": uid,
      "lastMessage": "UnBlocked",
      "lastMessageTime": Timestamp.now()
    }, SetOptions(merge: true));
  }

  static Future<String> reportUser(
      UserModel userModel, BuildContext context) async {
    var options = await showConfirmationDialog(
        context: context,
        title: AppStrings.pleaseSelectOption,
        actions: [
          const AlertDialogAction(
              label: AppStrings.option1, key: AppStrings.option1),
          const AlertDialogAction(
              label: AppStrings.option2, key: AppStrings.option2),
          const AlertDialogAction(
              label: AppStrings.option3, key: AppStrings.option3),
          const AlertDialogAction(
              label: AppStrings.option4, key: AppStrings.option4),
          const AlertDialogAction(
              label: AppStrings.option5, key: AppStrings.option5),
        ]);
    if ((options ?? "").isEmpty) {
      return "";
    }
    ReportUserModel reportMessageModel = ReportUserModel(
        id: AppFuncs.generateRandomString(15),
        messages: [options],
        reportTime: DateTime.now(),
        senderId: FirebaseAuth.instance.currentUser?.uid ?? "",
        reportedUserId: userModel.uid);
    await reportMessageModel.addreportUser();

    showOkAlertDialog(
        context: context,
        message: AppStrings.userReportedSuccessFully,
        title: AppStrings.reportUser);
    return options ?? "";
  }
}

String createThreadId(String s1, String s2) {
  return s1.compareTo(s2) >= 0 ? "${s1}__$s2" : "${s2}__$s1";
}
