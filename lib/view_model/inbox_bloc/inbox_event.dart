// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chat_with_bloc/model/thread_model.dart';

abstract class InboxEvent {}

class OnDispose extends InboxEvent {
  
}

class ThreadListener extends InboxEvent {
  final BuildContext context;
  ThreadListener({
    required this.context,
  });
}
 
class TreadListenerStream extends InboxEvent {
  final ThreadModel model;
  TreadListenerStream({
    required this.model,
  });
}
class MessageClearList extends InboxEvent{
  
}

class OnSearch extends InboxEvent {
  final String value;
  OnSearch({
    required this.value,
  });
}
