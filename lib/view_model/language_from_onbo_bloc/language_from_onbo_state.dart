class LanguageFromOnboState {
  final int currentIndex;
  LanguageFromOnboState({
    required this.currentIndex,
  });

  LanguageFromOnboState copyWith({
    int? currentIndex,
  }) {
    return LanguageFromOnboState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
