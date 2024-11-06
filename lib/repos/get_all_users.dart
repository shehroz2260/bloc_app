import 'package:chat_with_bloc/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetAllUsers {
  static Future<List<UserModel>> getAllUser() async {
    final snapShot = await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .where("uid",
            isNotEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
        .get();
    return snapShot.docs.map((e) => UserModel.fromMap(e.data())).toList();
  }
}
