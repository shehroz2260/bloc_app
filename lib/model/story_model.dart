import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String id;
  final String userId;
  final String userName;
  final String name;
  final int type;
  final String url;
  final String thumbnail;
  final DateTime createdAt;
  StoryModel({
    required this.id,
    required this.userId,
    required this.thumbnail,
    required this.userName,
    required this.name,
    required this.type,
    required this.url,
    required this.createdAt,
  });
  static const String tableName = 'story';

  StoryModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? name,
    String? thumbnail,
    int? type,
    String? url,
    DateTime? createdAt,
  }) {
    return StoryModel(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'thumbnail': thumbnail,
      'userId': userId,
      'userName': userName,
      'name': name,
      'type': type,
      'url': url,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'] as String,
      thumbnail: map['thumbnail'] ?? "",
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      name: map['name'] as String,
      type: map['type'] as int,
      url: map['url'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() {
    return 'StoryModel(thumbnail: $thumbnail, id: $id, userId: $userId, userName: $userName, name: $name, type: $type, url: $url, createdAt: $createdAt)';
  }
}
