import 'package:bloc/bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
