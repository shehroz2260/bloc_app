import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../view_model/user_base_bloc/user_base_event.dart';
import '../model/user_model.dart';

class AuthServices {
  static Future<void> signupUser(
      UserModel userModel, BuildContext context) async {
    var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email, password: userModel.password ?? "");
    String uid = user.user?.uid ?? "";
    userModel = userModel.copyWith(uid: uid);
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

  static Future<bool> isLoadData(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (uid.isEmpty) {
      return false;
    }
    final snapShot = await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(uid)
        .get();
    if (snapShot.exists) {
      context
          .read<UserBaseBloc>()
          .add(UpdateUserEvent(userModel: UserModel.fromMap(snapShot.data()!)));
      return true;
    }
    return false;
  }

  static Future<bool?> loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? account = await GoogleSignIn().signIn();
      if (account == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await GoogleSignIn().signOut();
      var user = await FirebaseFirestore.instance
          .collection(UserModel.tableName)
          .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
          .get();
      if (user.exists) {
        context
            .read<UserBaseBloc>()
            .add(UpdateUserEvent(userModel: UserModel.fromMap(user.data()!)));
        return true;
      }
      String uid = userCredential.user?.uid ?? "";
      UserModel userModel = UserModel.emptyModel;
      userModel = userModel.copyWith(
        uid: uid,
        firstName: userCredential.user?.displayName ?? "",
        profileImage: userCredential.user?.photoURL ?? "",
        email: userCredential.user?.email ?? "",
      );

      await FirebaseFirestore.instance
          .collection(UserModel.tableName)
          .doc(uid)
          .set(userModel.toMap());
      context.read<UserBaseBloc>().add(
          UpdateUserEvent(userModel: UserModel.fromMap(userModel.toMap())));
      return true;
    } on FirebaseAuthException catch (error) {
      showOkAlertDialog(
          context: context, message: error.message, title: error.code);

      return null;
    } catch (error) {
      showOkAlertDialog(
          context: context, message: error.toString(), title: "Error");
      return null;
    }
  }
}
