// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chat_with_bloc/model/story_model.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';

abstract class StoryEvent {}

class PickFile extends StoryEvent {
  final bool isVideo;
  final UserBaseBloc bloc;
  final BuildContext context;
  PickFile({
    required this.isVideo,
    required this.bloc,
    required this.context,
  });
}

class UploadStory extends StoryEvent {
  final BuildContext context;
  final int type;
  final UserBaseBloc bloc;

  UploadStory({
    required this.context,
    required this.type,
    required this.bloc,
  });
}

class GetStory extends StoryEvent {
  final BuildContext context;
  GetStory({
    required this.context,
  });
}

class StoryListener extends StoryEvent {
  final StoryModel model;
  StoryListener({
    required this.model,
  });
}

class ClearData extends StoryEvent {}

class OnDisposeStory extends StoryEvent {}

class FetchOthetStories extends StoryEvent {
  final UserModel userModel;
  FetchOthetStories({
    required this.userModel,
  });
}
