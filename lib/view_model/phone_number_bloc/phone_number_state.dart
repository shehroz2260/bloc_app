class PhoneNumberState {
  final String cCode;
  final String verificationId;
  PhoneNumberState({
    required this.cCode,
    required this.verificationId,
  });

  PhoneNumberState copyWith({
    String? cCode,
    String? verificationId,
  }) {
    return PhoneNumberState(
      cCode: cCode ?? this.cCode,
      verificationId: verificationId ?? this.verificationId,
    );
  }
 }

