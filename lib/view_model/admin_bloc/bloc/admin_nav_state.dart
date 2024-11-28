class AdminNavState {
  final int currentIndex;
  AdminNavState({
    required this.currentIndex,
  });

  AdminNavState copyWith({
    int? currentIndex,
  }) {
    return AdminNavState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
