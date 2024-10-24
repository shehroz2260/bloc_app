// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/services/auth_services.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/app_funcs.dart';
import 'package:chat_with_bloc/view/auth_view/sign_in_view.dart';
import 'package:chat_with_bloc/view/main_view/main_view.dart';
import 'package:chat_with_bloc/view/onboarding_views/dob_pick_view.dart';
import 'package:chat_with_bloc/view/onboarding_views/gender_view.dart';
import 'package:chat_with_bloc/view/onboarding_views/preference_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/char_model.dart';
import '../model/thread_model.dart';
import '../view_model/user_base_bloc/user_base_state.dart';

class NetworkService {
 static Future<void> gotoHomeScreen(BuildContext context,[bool isSplash = false]) async {
  // if(!(FirebaseAuth.instance.currentUser?.emailVerified?? false)){
  //   // showOkAlertDialog(context: context,message: "Please Verify your mail before login");
  //   Go.offAll(context, const SignInView());
  //   return;
  // }
  var isLoadData = await AuthServices.isLoadData(context);
  if (isSplash &&  
     !isLoadData) {
      Go.offAll(context, const SignInView());
    return;
  }
StreamSubscription<UserBaseState>? sub;
 sub =  context.read<UserBaseBloc>().stream.listen((state)async{
var user = state.userData;
await sub?.cancel();
 if(user.dob == DateTime(1800)){
  if(isSplash){
    await FirebaseAuth.instance.signOut();
    Go.offAll(context, const SignInView());
  }else{
    Go.offAll(context, const DobPickView());
  }
  return;
 }
  if(user.gender ==0){
  if(isSplash){
    await FirebaseAuth.instance.signOut();
    Go.offAll(context, const SignInView());
  }else{
    Go.offAll(context, const GenderView());
  }
  return;
 }
  if(user.preferGender ==-1){
  if(isSplash){
    await FirebaseAuth.instance.signOut();
    Go.offAll(context, const SignInView());
  }else{
    Go.offAll(context, const PreferenceView());
  }
  return;
 }
//   if((!await Permission.location.isGranted) ||
//           (!await Permission.locationWhenInUse.serviceStatus.isEnabled)|| (user.lat == 0.0 && user.lng == 0.0)){
//     if(isSplash){
// FirebaseAuth.instance.signOut();
//  Go.offAll(context, const SignInView());

//     }else{
//  Go.offAll(context, const LocationPermissionScreen());
//     }
//   return;
//  }
 Go.offAll(context, const MainView());
  });
}
  static void updateUser(UserModel user)async{
    await FirebaseFirestore.instance.collection(UserModel.tableName).doc(user.uid).set(user.toMap(),SetOptions(merge: true));
  }

   static Future<void> likeUser(UserModel liker, UserModel likee, BuildContext context) async {

    bool isMatch = likee.myLikes.contains(liker.uid) ;

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
      showOkAlertDialog(context: context,message: "Congrats you have new friend ${likee.name}");
      // await sendMatchNotification(liker, likee);
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
 var thread = ThreadModel(lastMessage: message??"", lastMessageTime: DateTime.now(), participantUserList: [liker.uid, likee.uid], senderId: liker.uid, messageCount: 1, threadId: threadId, messageDelete: [], isPending: false, isBlocked: false);
 
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


}

String createThreadId(String s1, String s2) {
  return s1.compareTo(s2) >= 0 ? "${s1}__$s2" : "${s2}__$s1";
}