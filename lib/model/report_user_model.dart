import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class ReportUserModel {
  static String tableName = "reported_users";
  final String id;
  final List<dynamic> messages;
  final DateTime reportTime;
  final String senderId;
  final String reportedUserId;
  UserModel? reportUser;
  UserModel? senderUser;
  ReportUserModel({
    required this.id,
    required this.messages,
    required this.reportTime,
    required this.senderId,
    required this.reportedUserId,
    this.reportUser,
    this.senderUser,
  });

  ReportUserModel copyWith({
    String? id,
    List<dynamic>? messages,
    DateTime? reportTime,
    String? senderId,
    String? reportedUserId,
    UserModel? reportUser,
    UserModel? senderUser,
  }) {
    return ReportUserModel(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      reportTime: reportTime ?? this.reportTime,
      senderId: senderId ?? this.senderId,
      reportedUserId: reportedUserId ?? this.reportedUserId,
      reportUser: reportUser ?? this.reportUser,
      senderUser: senderUser ?? this.senderUser,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'messages': messages,
      'reportTime': Timestamp.fromDate(reportTime),
      'senderId': senderId,
      'reportedUserId': reportedUserId,
    };
  }

  factory ReportUserModel.fromMap(Map<String, dynamic> map) {
    return ReportUserModel(
      id: map['id'] as String,
      messages: List<dynamic>.from((map['messages'] as List<dynamic>)),
      reportTime: (map['reportTime'] as Timestamp).toDate(),
      senderId: map['senderId'] as String,
      reportedUserId: map['reportedUserId'] as String,
    );
  }
  Future<void> addreportUser() async {
    await FirebaseFirestore.instance
        .collection(tableName)
        .doc(id)
        .set(toMap(), SetOptions(merge: true));
  }

  @override
  String toString() {
    return 'ReportUserModel(id: $id, messages: $messages, reportTime: $reportTime, senderId: $senderId, reportedUserId: $reportedUserId, reportUser: $reportUser, senderUser: $senderUser)';
  }
}
