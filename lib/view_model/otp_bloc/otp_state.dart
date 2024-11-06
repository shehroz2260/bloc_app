class OtpState {
  final int timer;
  OtpState({
    required this.timer,
  });

  OtpState copyWith({
    int? timer,
  }) {
    return OtpState(
      timer: timer ?? this.timer,
    );
  }
}
