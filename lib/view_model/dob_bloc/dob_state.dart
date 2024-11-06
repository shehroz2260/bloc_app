// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

class DobState {
  final DateTime? dob;
  final File? image;
  final String imgString;
  final String dateString;
  DobState(
      {this.dob,
      this.image,
      required this.imgString,
      required this.dateString});

  DobState copyWith({
    DateTime? dob,
    File? image,
    String? imgString,
    String? dateString,
  }) {
    return DobState(
      dob: dob ?? this.dob,
      image: image ?? this.image,
      imgString: imgString ?? this.imgString,
      dateString: dateString ?? this.dateString,
    );
  }
}
