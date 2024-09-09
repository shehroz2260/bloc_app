// ignore_for_file: public_member_api_docs, sort_constructors_first

class DobState {
  final DateTime dob;
  DobState({
    required this.dob,
  });

  DobState copyWith({
    DateTime? dob,
  }) {
    return DobState(
      dob: dob ?? this.dob,
    );
  }
 }

