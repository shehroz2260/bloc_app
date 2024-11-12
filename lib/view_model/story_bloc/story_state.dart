import 'dart:io';
import 'package:chat_with_bloc/model/story_model.dart';

class StoryState {
  final File? file;
  final bool isLoading;
  final File? thumbnail;
  final List<StoryModel> storyList;
  final List<OtherStoryModel> otherList;
  StoryState({
    this.file,
    required this.isLoading,
    this.thumbnail,
    required this.storyList,
    required this.otherList,
  });

  StoryState copyWith({
    File? file,
    bool? isLoading,
    File? thumbnail,
    List<OtherStoryModel>? otherList,
    List<StoryModel>? storyList,
  }) {
    return StoryState(
      file: file ?? this.file,
      otherList: otherList ?? this.otherList,
      isLoading: isLoading ?? this.isLoading,
      thumbnail: thumbnail ?? this.thumbnail,
      storyList: storyList ?? this.storyList,
    );
  }
}

class OtherStoryModel {
  final String userName;
  final String userImage;
  final List<StoryModel> list;
  OtherStoryModel({
    required this.userName,
    required this.userImage,
    required this.list,
  });

  OtherStoryModel copyWith({
    String? userName,
    String? userImage,
    List<StoryModel>? list,
  }) {
    return OtherStoryModel(
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      list: list ?? this.list,
    );
  }

  factory OtherStoryModel.fromMap(Map<String, dynamic> map) {
    return OtherStoryModel(
      userName: map['userName'] ?? "",
      userImage: map['userImage'] ?? "",
      list: List<StoryModel>.from(
        (map['list'] as List<int>).map<StoryModel>(
          (x) => StoryModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toString() =>
      'OtherStoryModel(userName: $userName, userImage: $userImage, list: $list)';
}
