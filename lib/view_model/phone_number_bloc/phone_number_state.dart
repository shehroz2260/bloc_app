class PhoneNumberState {
  final String phoneNumer;
  final String cCode;
  final String verificationId;
  PhoneNumberState({
    required this.phoneNumer,
    required this.cCode,
    required this.verificationId,
  });

  PhoneNumberState copyWith({
    String? phoneNumer,
    String? cCode,
    String? verificationId,
  }) {
    return PhoneNumberState(
      phoneNumer: phoneNumer ?? this.phoneNumer,
      cCode: cCode ?? this.cCode,
      verificationId: verificationId ?? this.verificationId,
    );
  }
 }

