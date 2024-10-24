import 'package:chat_with_bloc/model/thread_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/char_model.dart';

class ChatRepo {
  static Query<Map<String, dynamic>> ref(String id){
    return FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .doc(id)
        .collection(ChatModel.tableName)
        .orderBy("messageTime", descending: true);
  }
}