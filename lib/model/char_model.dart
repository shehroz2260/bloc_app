class ChatModel {
  static String tableName = "chats";
  final String id;
  final String message;
  final DateTime messageTime;
  final String senderId;
  final bool isRead;
  final String threadId;
  final MediaModel? media;
  ChatModel( {
    required this.id,
    required this.threadId,
    required this.message,
    required this.messageTime,
    required this.senderId,
    required this.isRead,
    this.media,
  });

  ChatModel copyWith({
    String? id,
    String? message,
    String? threadId,
    DateTime? messageTime,
    String? senderId,
    bool? isRead,
    DateTime? lastMessageTime,
    MediaModel? media,
  }) {
    return ChatModel(
        id: id ?? this.id,
        threadId: threadId ?? this.threadId,
        message: message ?? this.message,
        messageTime: messageTime ?? this.messageTime,
        senderId: senderId ?? this.senderId,
        isRead: isRead ?? this.isRead,
        media: media ?? this.media,
        );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'threadId': threadId,
      'message': message,
      'messageTime': messageTime.toIso8601String(),
      'senderId': senderId,
      'isRead': isRead,
      'media': media?.toMap(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ??"",
      threadId: map["threadId"]??"",
      message: map['message'] ??"",
      messageTime:DateTime.parse(map['messageTime'] ??""),
      senderId: map['senderId'] ??"",
      isRead: map['isRead'] as bool,
      media: map['media'] != null ? MediaModel.fromMap(map['media']) : null,
    );
  }

  @override
  String toString() {
    return 'ChatModel( id: $id, message: $message, messageTime: $messageTime, senderId: $senderId, isRead: $isRead, media: $media, threadId: $threadId)';
  }
}

class MediaModel {
  final String id;
  final int type;
  final String? thumbnail;
  final String url;
  final DateTime createdAt;
  final String name;
  MediaModel({
    required this.type,
    this.thumbnail,
    required this.id,
    required this.url,
    required this.createdAt,
    required this.name,
  });

  MediaModel copyWith({
    String? id,
    int? type,
    String? thumbnail,
    String? url,
    DateTime? createdAt,
    String? name,
  }) {
    return MediaModel(
      id: id ?? this.id,
      type: type ?? this.type,
      thumbnail: thumbnail ?? this.thumbnail,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'url': url,
      'thumbnail': thumbnail,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'name': name,
    };
  }

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      id: map['id'] as String,
      url: map['url'] as String,
      thumbnail: map['thumbnail'] ?? "",
      type: map['type'],
      createdAt: DateTime.parse(map['createdAt'] ??""),
      name: map['name'] as String,
    );
  }

  @override
  String toString() {
    return 'MediaModel(thumbnail: $thumbnail, type: $type, id: $id, url: $url, createdAt: $createdAt, name: $name)';
  }
}
