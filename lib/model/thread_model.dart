import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_model.dart';

class ThreadModel {
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<dynamic> participantUserList;
  final String senderId;
  final int messageCount;
  final String threadId;
  UserModel? userDetail;
  bool isSelect;
  final List<MessageDeleteModel> messageDelete;
  final bool isPending;
  final bool isBlocked;
  ThreadModel({
    required this.lastMessage,
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
    String? senderId,
    int? messageCount,
    String? threadId,
    UserModel? userDetail,
    bool? isPending,
    bool? isBlocked,
    bool? isSelect,
    List<MessageDeleteModel>? messageDelete,
  }) {
    return ThreadModel(
      messageDelete: messageDelete ?? this.messageDelete,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      participantUserList: participantUserList ?? this.participantUserList,
      senderId: senderId ?? this.senderId,
      messageCount: messageCount ?? this.messageCount,
      threadId: threadId ?? this.threadId,
      userDetail: userDetail ?? this.userDetail,
      isPending: isPending ?? this.isPending,
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
      'senderId': senderId,
      'messageCount': messageCount,
      'threadId': threadId,
      'isPending': isPending,
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
      senderId: map['senderId'] as String,
      messageCount: map['messageCount'] as int,
      threadId: map['threadId'] as String,
      isPending: map['isPending'] as bool,
      isBlocked: map['isBlocked'] as bool,
    );
  }
  void readMessage(BuildContext context) async {
    try {
      if (senderId != context.read<UserBaseBloc>().state.userData.uid) {
        await FirebaseFirestore.instance
            .collection(tableName)
            .doc(threadId)
            .update({'messageCount': 0});
      }
    } on FirebaseException catch (e) {
      showOkAlertDialog(context: context, message: e.message);
    }
  }

  // static void deleteMessages(ThreadModel threadModel, bool isAdmin) async {
  //   final baseController = Get.put(BaseController(() {}));
  //   MessageDeleteModel model = MessageDeleteModel(
  //       id: AdminBaseController.userData.uid, deleteAt: DateTime.now());
  //   final msgDelete = threadModel.messageDelete
  //       .where((element) => element.id == AdminBaseController.userData.uid)
  //       .toList();
  //   if (msgDelete.isEmpty) {
  //     threadModel.messageDelete.add(model);
  //   } else if (threadModel.messageDelete[0].id ==
  //       AdminBaseController.userData.uid) {
  //     threadModel.messageDelete[0] =
  //         msgDelete[0].copyWith(deleteAt: DateTime.now());
  //   } else {
  //     threadModel.messageDelete[1] =
  //         msgDelete[0].copyWith(deleteAt: DateTime.now());
  //   }
  //   threadModel = threadModel.copyWith(
  //       lastMessage: '',
  //       lastMessageTime: DateTime.now(),
  //       messageCount: 0,
  //       messageDelete: threadModel.messageDelete);

  //   try {
  //     baseController.showProgress();
  //     FirebaseFirestore.instance
  //         .collection(isAdmin ? ThreadModel.adminThread : ThreadModel.tableName)
  //         .doc(threadModel.threadId)
  //         .update(threadModel.toMap());
  //     // FirebaseFirestore.instance
  //     //     .collection(ThreadModel.tableName)
  //     //     .doc(threadId)
  //     //     .collection(ChatModel.tableName)
  //     //     .get()
  //     //     .then((snapshot) {
  //     //   for (DocumentSnapshot ds in snapshot.docs) {
  //     //     ds.reference.delete();
  //     //   }
  //     // });
  //     baseController.hideProgress();
  //   } catch (e) {
  //     baseController.hideProgress();
  //   }
  // }

  @override
  String toString() {
    return 'ThreadModel(messageDelete: $messageDelete, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime, participantUserList: $participantUserList, senderId: $senderId, messageCount: $messageCount, threadId: $threadId, userDetail: $userDetail, isPending: $isPending, isBlocked: $isBlocked)';
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
