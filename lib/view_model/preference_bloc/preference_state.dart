class PreferenceState {
  final int prefGenders;
  final List<int> intrestList;
  PreferenceState({
    required this.prefGenders,
    required this.intrestList,
  });

  PreferenceState copyWith({int? prefGenders, List<int>? intrestList}) {
    return PreferenceState(
      prefGenders: prefGenders ?? this.prefGenders,
      intrestList: intrestList ?? this.intrestList,
    );
  }
}
