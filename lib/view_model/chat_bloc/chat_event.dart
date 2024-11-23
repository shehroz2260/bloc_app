// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chat_with_bloc/model/char_model.dart';
import 'package:chat_with_bloc/model/thread_model.dart';

import '../../model/user_model.dart';

abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  final String threadId;
  final bool isForVc;
  final ThreadModel threadModel;
  final TextEditingController textEditingController;
  final BuildContext context;
  SendMessage({
    required this.threadId,
    required this.isForVc,
    required this.threadModel,
    required this.textEditingController,
    required this.context,
  });
}

class LoadChat extends ChatEvent {
  final String thradId;
  final ThreadModel model;
  LoadChat({
    required this.thradId,
    required this.model,
  });
}

class ChatListener extends ChatEvent {
  final String thradId;
  final ThreadModel model;
  ChatListener({
    required this.thradId,
    required this.model,
  });
}

class ShowTime extends ChatEvent {
  final int index;
  ShowTime({
    required this.index,
  });
}

class StartOrStopRecording extends ChatEvent {
  final BuildContext context;
  final String threadId;
  final ThreadModel model;
  StartOrStopRecording({
    required this.context,
    required this.threadId,
    required this.model,
  });
}

class StartTimer extends ChatEvent {}

class InitiaLizeAudioController extends ChatEvent {}

class OnChangeTextField extends ChatEvent {
  final String text;
  OnChangeTextField({
    required this.text,
  });
}

class UpdateTimer extends ChatEvent {
  final Duration duration;
  UpdateTimer({
    required this.duration,
  });
}

class PickFileEvent extends ChatEvent {
  final BuildContext context;
  PickFileEvent({
    required this.context,
  });
}

class ClearData extends ChatEvent {}

class ChatListenerStream extends ChatEvent {
  final ChatModel model;
  ChatListenerStream({
    required this.model,
  });
}

class DownloadMedia extends ChatEvent {
  final BuildContext context;
  final ChatModel chat;
  DownloadMedia({required this.context, required this.chat});
}

class DownLoadMediaForApp extends ChatEvent {
  final BuildContext context;
  final ChatModel chat;
  DownLoadMediaForApp({required this.context, required this.chat});
}

class OnListenThread extends ChatEvent {
  final ThreadModel threadModel;
  final BuildContext context;
  OnListenThread({required this.threadModel, required this.context});
}

class ClearChat extends ChatEvent {
  final BuildContext context;
  ClearChat({
    required this.context,
  });
}

class BlockUSerEvent extends ChatEvent {}

class ListenUserEvent extends ChatEvent {
  final String id;
  ListenUserEvent({
    required this.id,
  });
}

class OpenOptions extends ChatEvent {
  final BuildContext context;
  final UserModel userModel;
  OpenOptions({
    required this.context,
    required this.userModel,
  });
}
