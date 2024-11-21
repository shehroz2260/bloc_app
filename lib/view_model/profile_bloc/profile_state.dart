class ProfileState {
  final String defaultPaymentMethodId;
  final List<dynamic> cardList;
  ProfileState({
    required this.defaultPaymentMethodId,
    required this.cardList,
  });

  ProfileState copyWith({
    String? defaultPaymentMethodId,
    List<dynamic>? cardList,
  }) {
    return ProfileState(
      defaultPaymentMethodId:
          defaultPaymentMethodId ?? this.defaultPaymentMethodId,
      cardList: cardList ?? this.cardList,
    );
  }
}
