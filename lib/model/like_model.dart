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
