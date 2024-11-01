// ignore_for_file: public_member_api_docs, sort_constructors_first
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

