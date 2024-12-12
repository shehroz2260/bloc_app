// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chat_with_bloc/model/posts_model.dart';

abstract class PostEvent {}

class ListenPost extends PostEvent {
  final BuildContext context;
  ListenPost({
    required this.context,
  });
}

class ListPostModel extends PostEvent {
  final PostsModel postsModel;
  ListPostModel({
    required this.postsModel,
  });
}

class OnPostLoad extends PostEvent {
  final BuildContext context;
  OnPostLoad({
    required this.context,
  });
}

class OnDispose extends PostEvent {}
