import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc()
      : super(ProfileState(cardList: [], defaultPaymentMethodId: "")) {
    on<OninitProfileFunction>(_onInitProfileFunc);
  }

  _onInitProfileFunc(
      OninitProfileFunction event, Emitter<ProfileState> emit) async {
    try {
      var list = await ApiServices.getCardList(event.context);
      emit(state.copyWith(
          cardList: list,
          defaultPaymentMethodId:
              list.where((e) => e['isDefault']).toList().firstOrNull?['id'] ??
                  ''));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
