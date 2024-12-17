import 'package:image_picker/image_picker.dart';

class CreatePostState {
  final List<XFile> images;
  CreatePostState({
    required this.images,
  });

  CreatePostState copyWith({
    List<XFile>? images,
  }) {
    return CreatePostState(
      images: images ?? this.images,
    );
  }
}
