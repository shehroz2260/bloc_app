// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chat_with_bloc/model/char_model.dart';
import 'package:chat_with_bloc/model/thread_model.dart';

class ChatState {
  final List<ChatModel> messageList;
  final int limit;
  final bool isLoading;
  final bool messageSending;
  final bool isRecording;
  final bool isFirstMsg;
  final File? pickFile;
  final File? thumbnail;
  final String? audioUrl;
  final Duration duration;
  // final ThreadModel threadModel;
  final String text;
  ChatState({
    required this.messageList,
    required this.limit,
    required this.isFirstMsg,
    // required this.threadModel,
    required this.isLoading,
    required this.messageSending,
    required this.isRecording,
    this.pickFile,
    this.thumbnail,
    this.audioUrl,
    required this.duration,
    required this.text,
  });

  ChatState copyWith({
    List<ChatModel>? messageList,
    int? limit,
    bool? isLoading,
    bool? isFirstMsg,
    ThreadModel? threadModel,
    bool? messageSending,
    bool? isRecording,
    File? pickFile,
    File? thumbnail,
    String? audioUrl,
    Duration? duration,
    String? text,
  }) {
    return ChatState(
      messageList: messageList ?? this.messageList,
      limit: limit ?? this.limit,
      isFirstMsg: isFirstMsg ?? this.isFirstMsg,
      // threadModel: threadModel ?? this.threadModel,
      isLoading: isLoading ?? this.isLoading,
      messageSending: messageSending ?? this.messageSending,
      isRecording: isRecording ?? this.isRecording,
      pickFile: pickFile ?? this.pickFile,
      thumbnail: thumbnail ?? this.thumbnail,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      text: text ?? this.text,
    );
  }
}
