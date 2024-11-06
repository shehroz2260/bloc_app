class GenderState {
  final int gender;
  GenderState({
    required this.gender,
  });

  GenderState copyWith({
    int? gender,
  }) {
    return GenderState(
      gender: gender ?? this.gender,
    );
  }
}
