import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/user_base_bloc/user_base_event.dart';
import '../model/user_model.dart';

class AuthServices {
     static Future<void> signupUser(UserModel userModel, BuildContext context) async {
    var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email , password: userModel.password ?? "");
    String uid = user.user?.uid ?? "";
 userModel =  userModel.copyWith(uid: uid);
 context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: userModel));
    await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(uid)
        .set(userModel.toMap());
  }

  static loginUser(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<bool> isLoadData(BuildContext context)async {
    final uid = FirebaseAuth.instance.currentUser?.uid??"";
    if(uid.isEmpty){
      return false;
    }
      final snapShot = await FirebaseFirestore.instance.collection(UserModel.tableName).doc(uid).get();
      if(snapShot.exists){
        context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: UserModel.fromMap(snapShot.data()!)));
        return true;
      }
      return false;
  }
}