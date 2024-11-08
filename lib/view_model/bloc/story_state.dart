// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chat_with_bloc/model/story_model.dart';

class StoryState {
  final File? file;
  final bool isLoading;
  final File? thumbnail;
  final List<StoryModel> storyList;
  StoryState({
    this.file,
    required this.isLoading,
    this.thumbnail,
    required this.storyList,
  });

  StoryState copyWith({
    File? file,
    bool? isLoading,
    File? thumbnail,
    List<StoryModel>? storyList,
  }) {
    return StoryState(
      file: file ?? this.file,
      isLoading: isLoading ?? this.isLoading,
      thumbnail: thumbnail ?? this.thumbnail,
      storyList: storyList ?? this.storyList,
    );
  }
}
