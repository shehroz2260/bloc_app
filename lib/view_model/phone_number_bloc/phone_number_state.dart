class PhoneNumberState {
  final String cCode;
  PhoneNumberState({
    required this.cCode,
  });

  PhoneNumberState copyWith({
    String? cCode,
    String? verificationId,
  }) {
    return PhoneNumberState(
      cCode: cCode ?? this.cCode,
    );
  }
 }

