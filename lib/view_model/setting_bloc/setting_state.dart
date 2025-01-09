class SettingState {
  final bool isOnNotification;
  final bool isIgnitoMode;
  SettingState({
    required this.isOnNotification,
    required this.isIgnitoMode,
  });

  SettingState copyWith({bool? isOnNotification, bool? isIgnitoMode}) {
    return SettingState(
      isOnNotification: isOnNotification ?? this.isOnNotification,
      isIgnitoMode: isIgnitoMode ?? this.isIgnitoMode,
    );
  }
}
