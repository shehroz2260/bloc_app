import 'package:cloud_firestore/cloud_firestore.dart';

class PostsModel {
  static const tableName = "posts";

  final String id;
  final String uid;
  final String text;
  final String avatar;
  final String userName;
  final List<dynamic> imageList;
  final DateTime createdAt;
  PostsModel({
    required this.id,
    required this.uid,
    required this.text,
    required this.avatar,
    required this.userName,
    required this.imageList,
    required this.createdAt,
  });

  PostsModel copyWith({
    String? id,
    String? uid,
    String? text,
    String? avatar,
    String? userName,
    List<dynamic>? imageList,
    DateTime? createdAt,
  }) {
    return PostsModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      text: text ?? this.text,
      avatar: avatar ?? this.avatar,
      userName: userName ?? this.userName,
      imageList: imageList ?? this.imageList,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'text': text,
      'avatar': avatar,
      'userName': userName,
      'imageList': imageList,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PostsModel.fromMap(Map<String, dynamic> map) {
    return PostsModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      text: map['text'] as String,
      avatar: map['avatar'] as String,
      userName: map['userName'] as String,
      imageList: List<dynamic>.from((map['imageList'] as List<dynamic>)),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() {
    return 'PostsModel(id: $id, uid: $uid, text: $text, avatar: $avatar, userName: $userName, imageList: $imageList, createdAt: $createdAt)';
  }
}
