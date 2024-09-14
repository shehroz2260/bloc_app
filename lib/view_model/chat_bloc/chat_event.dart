// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chat_with_bloc/model/char_model.dart';

abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  final String threadId;
  final bool isForVc;
  final TextEditingController textEditingController;
  final BuildContext context;
  SendMessage({required this.threadId,required this.context,required this.textEditingController, this.isForVc = false});
}

class LoadChat extends ChatEvent {
  final String thradId;
  LoadChat({
    required this.thradId,
  });
}
class ChatListener extends ChatEvent{
   final String thradId;
  ChatListener({
    required this.thradId,
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
  StartOrStopRecording({
    required this.context,
    required this.threadId,
  });
}
class StartTimer extends ChatEvent {
 
}
class InitiaLizeAudioController extends ChatEvent {
 
}

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

class ClearData extends ChatEvent{

}

class ChatListenerStream extends ChatEvent {
  final ChatModel model;
  ChatListenerStream({
    required this.model,
  });
}


class DownloadMedia extends ChatEvent {
  final BuildContext context;
  final ChatModel chat;
  DownloadMedia({
    required this.context,
    required this.chat
  });
}

class DownLoadMediaForApp extends ChatEvent {
  final BuildContext context;
  final ChatModel chat;
  DownLoadMediaForApp({
    required this.context,
    required this.chat
  });
}
