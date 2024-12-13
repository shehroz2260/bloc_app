// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chat_with_bloc/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'posts_model.dart';

class LikeModel {
  static const tableName = "likes";
  final String likeruid;
  LikeModel({
    required this.likeruid,
  });

  Future addNewLikeOrUpdate(PostsModel communityModel) async {
    var doc = await FirebaseFirestore.instance
        .collection(PostsModel.tableName)
        .doc(communityModel.id)
        .collection(tableName)
        .where('likeruid', isEqualTo: likeruid)
        .get();
    if (doc.docs.isNotEmpty) {
      FirebaseFirestore.instance
          .collection(PostsModel.tableName)
          .doc(communityModel.id)
          .collection(tableName)
          .doc(likeruid)
          .delete();
      return;
    }
    await FirebaseFirestore.instance
        .collection(PostsModel.tableName)
        .doc(communityModel.id)
        .collection(tableName)
        .doc(likeruid)
        .set(toMap(), SetOptions(merge: true));
  }

  LikeModel copyWith({
    String? id,
    String? likeruid,
  }) {
    return LikeModel(
      likeruid: likeruid ?? this.likeruid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'likeruid': likeruid,
    };
  }

  factory LikeModel.fromMap(Map<String, dynamic> map) {
    return LikeModel(
      likeruid: map['likeruid'] as String,
    );
  }

  @override
  String toString() => 'LikeModel( likeruid: $likeruid)';
}

class CommentModel {
  final String comment;
  final String id;
  final String uid;
  UserModel? userData;
  final DateTime createdAt;
  CommentModel({
    required this.comment,
    required this.id,
    required this.uid,
    required this.createdAt,
  });
  static const tableName = "comments";
  CommentModel copyWith({
    String? comment,
    String? id,
    String? uid,
    DateTime? createdAt,
  }) {
    return CommentModel(
      comment: comment ?? this.comment,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comment': comment,
      'id': id,
      'uid': uid,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      comment: map['comment'] ?? "",
      id: map['id'] ?? "",
      uid: map['uid'] ?? "",
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(comment: $comment, id: $id, uid: $uid, createdAt: $createdAt)';
  }
}
