import 'package:flutter/material.dart';
import '../../../model/thread_model.dart';

abstract class AdminInboxEvent {}

class OnDispose extends AdminInboxEvent {}

class ThreadListener extends AdminInboxEvent {
  final BuildContext context;
  ThreadListener({
    required this.context,
  });
}

class TreadListenerStream extends AdminInboxEvent {
  final ThreadModel model;
  TreadListenerStream({
    required this.model,
  });
}

class MessageClearList extends AdminInboxEvent {}
