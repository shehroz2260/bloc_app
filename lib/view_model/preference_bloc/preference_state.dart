class PreferenceState {
  final int prefGenders;
  PreferenceState({
    required this.prefGenders,
  });

  PreferenceState copyWith({
    int? prefGenders,
  }) {
    return PreferenceState(
      prefGenders: prefGenders ?? this.prefGenders,
    );
  }
 }

