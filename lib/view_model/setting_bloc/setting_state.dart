class SettingState {
  final bool isOnNotification;
  SettingState({
    required this.isOnNotification,
  });

  SettingState copyWith({
    bool? isOnNotification,
  }) {
    return SettingState(
      isOnNotification: isOnNotification ?? this.isOnNotification,
    );
  }
}
