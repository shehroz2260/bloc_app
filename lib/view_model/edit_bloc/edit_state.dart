// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

class EditState {
  final File? imageFile;
  final bool isEdit;
  final DateTime dob;
  EditState({
    this.imageFile,
    required this.isEdit,
    required this.dob,
  });

  EditState copyWith({
    File? imageFile,
    bool? isEdit,
    DateTime? dob,
  }) {
    return EditState(
      imageFile: imageFile ?? this.imageFile,
      isEdit: isEdit ?? this.isEdit,
      dob: dob ?? this.dob,
    );
  }
}
