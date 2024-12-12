import 'package:chat_with_bloc/model/posts_model.dart';

class PostState {
  final List<PostsModel> postList;
  final int limit;
  PostState({
    required this.postList,
    required this.limit,
  });

  PostState copyWith({
    List<PostsModel>? postList,
    int? limit,
  }) {
    return PostState(
      postList: postList ?? this.postList,
      limit: limit ?? this.limit,
    );
  }
}
