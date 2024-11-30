import 'dart:developer';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_model.dart';

class ThreadModel {
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<dynamic> participantUserList;
  final List<dynamic> activeUserList;
  final List<String> blockUserList;
  final String senderId;
  final bool isAdmin;
  final int messageCount;
  final String threadId;
  UserModel? userDetail;
  bool isSelect;
  final List<MessageDeleteModel> messageDelete;
  final bool isPending;
  final bool isBlocked;
  ThreadModel({
    required this.lastMessage,
    required this.activeUserList,
    required this.isAdmin,
    required this.blockUserList,
    required this.lastMessageTime,
    required this.participantUserList,
    required this.senderId,
    required this.messageCount,
    required this.threadId,
    required this.messageDelete,
    this.userDetail,
    this.isSelect = false,
    required this.isPending,
    required this.isBlocked,
  });
  static String tableName = "threads";
  static String adminThread = "admin&userthread";

  ThreadModel copyWith({
    String? lastMessage,
    DateTime? lastMessageTime,
    List<dynamic>? participantUserList,
    List<dynamic>? activeUserList,
    List<String>? blockUserList,
    String? senderId,
    int? messageCount,
    String? threadId,
    UserModel? userDetail,
    bool? isPending,
    bool? isBlocked,
    bool? isAdmin,
    bool? isSelect,
    List<MessageDeleteModel>? messageDelete,
  }) {
    return ThreadModel(
      messageDelete: messageDelete ?? this.messageDelete,
      blockUserList: blockUserList ?? this.blockUserList,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      participantUserList: participantUserList ?? this.participantUserList,
      activeUserList: activeUserList ?? this.activeUserList,
      senderId: senderId ?? this.senderId,
      messageCount: messageCount ?? this.messageCount,
      threadId: threadId ?? this.threadId,
      userDetail: userDetail ?? this.userDetail,
      isPending: isPending ?? this.isPending,
      isAdmin: isAdmin ?? this.isAdmin,
      isBlocked: isBlocked ?? this.isBlocked,
      isSelect: isSelect ?? this.isSelect,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageDelete': messageDelete.map((e) => e.toMap()).toList(),
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'participantUserList': participantUserList,
      'activeUserList': activeUserList,
      'blockUserList': blockUserList,
      'senderId': senderId,
      'messageCount': messageCount,
      'threadId': threadId,
      'isPending': isPending,
      'isAdmin': isAdmin,
      'isBlocked': isBlocked,
    };
  }

  factory ThreadModel.fromMap(Map<String, dynamic> map) {
    return ThreadModel(
      messageDelete: List<MessageDeleteModel>.from(
        (map['messageDelete'] as List).map<MessageDeleteModel>(
          (x) => MessageDeleteModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      lastMessage: map['lastMessage'] as String,
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
      participantUserList:
          List<dynamic>.from((map['participantUserList'] as List<dynamic>)),
      activeUserList:
          List<dynamic>.from((map['activeUserList'] as List<dynamic>)),
      blockUserList: List<String>.from((map['blockUserList'] ?? [])),
      senderId: map['senderId'] as String,
      messageCount: map['messageCount'] as int,
      threadId: map['threadId'] as String,
      isPending: map['isPending'] as bool,
      isBlocked: map['isBlocked'] as bool,
      isAdmin: map['isAdmin'] ?? false,
    );
  }
  void readMessage() async {
    try {
      if (senderId != (FirebaseAuth.instance.currentUser?.uid ?? "")) {
        await FirebaseFirestore.instance
            .collection(tableName)
            .doc(threadId)
            .update({'messageCount': 0});
      }
    } on FirebaseException catch (e) {
      log("^^${e.message}");
    }
  }

  static Future<void> deleteMessages(
      ThreadModel threadModel, BuildContext context) async {
    threadModel = threadModel.copyWith(lastMessage: "");
    LoadingDialog.showProgress(context);
    int index = -1;
    final cUser = context.read<UserBaseBloc>().state.userData;
    MessageDeleteModel model =
        MessageDeleteModel(id: cUser.uid, deleteAt: DateTime.now());
    index = threadModel.messageDelete.indexWhere((e) => e.id == cUser.uid);
    if (index != -1) {
      threadModel.messageDelete[index] =
          threadModel.messageDelete[index].copyWith(deleteAt: DateTime.now());
      threadModel =
          threadModel.copyWith(messageDelete: threadModel.messageDelete);
    } else {
      threadModel.messageDelete.add(model);
    }

    try {
      FirebaseFirestore.instance
          .collection(ThreadModel.tableName)
          .doc(threadModel.threadId)
          .set(threadModel.toMap(), SetOptions(merge: true));
      // FirebaseFirestore.instance
      //     .collection(ThreadModel.tableName)
      //     .doc(threadId)
      //     .collection(ChatModel.tableName)
      //     .get()
      //     .then(() {
      //   for (DocumentSnapshot ds in snapshot.docs) {
      //     ds.reference.delete();
      //   }
      // });
      LoadingDialog.hideProgress(context);
    } catch (e) {
      LoadingDialog.hideProgress(context);
    }
  }

  @override
  String toString() {
    return 'ThreadModel(isAdmin: $isAdmin, messageDelete: $messageDelete, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime, participantUserList: $participantUserList, senderId: $senderId, messageCount: $messageCount, threadId: $threadId, userDetail: $userDetail, isPending: $isPending, isBlocked: $isBlocked)';
  }
}

class MessageDeleteModel {
  final String id;
  final DateTime deleteAt;
  MessageDeleteModel({
    required this.id,
    required this.deleteAt,
  });

  MessageDeleteModel copyWith({
    String? id,
    DateTime? deleteAt,
  }) {
    return MessageDeleteModel(
      id: id ?? this.id,
      deleteAt: deleteAt ?? this.deleteAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'deleteAt': Timestamp.fromDate(deleteAt),
    };
  }

  factory MessageDeleteModel.fromMap(Map<String, dynamic> map) {
    return MessageDeleteModel(
      id: map['id'] as String,
      deleteAt: (map['deleteAt'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() => 'MessageDeleteModel(id: $id, deleteAt: $deleteAt)';
}
