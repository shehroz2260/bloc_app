import 'dart:io';

class EditState {
  final File? imageFile;
  final bool isEdit;
  EditState({
     this.imageFile,
     required this.isEdit,
  });

  EditState copyWith({
    File? imageFile,
    bool? isEdit,
  }) {
    return EditState(
      imageFile: imageFile ?? this.imageFile,
      isEdit: isEdit ?? this.isEdit,
    );
  }
 }

