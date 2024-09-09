// ignore_for_file: use_build_context_synchronously
import 'dart:async';

import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/services/auth_services.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/view/auth_view/sign_in_view.dart';
import 'package:chat_with_bloc/view/main_view/main_view.dart';
import 'package:chat_with_bloc/view/onboarding_views/dob_pick_view.dart';
import 'package:chat_with_bloc/view/onboarding_views/gender_view.dart';
import 'package:chat_with_bloc/view/onboarding_views/preference_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/user_base_bloc/user_base_state.dart';

class NetworkService {
 static Future<void> gotoHomeScreen(BuildContext context,[bool isSplash = false]) async {
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
}