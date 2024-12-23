class CreatePostState {
  final List<String> images;
  CreatePostState({
    required this.images,
  });

  CreatePostState copyWith({
    List<String>? images,
  }) {
    return CreatePostState(
      images: images ?? this.images,
    );
  }
}
