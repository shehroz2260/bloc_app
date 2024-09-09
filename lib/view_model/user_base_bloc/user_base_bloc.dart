import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'user_base_event.dart';
import 'user_base_state.dart';

class UserBaseBloc extends Bloc<UserBaseEvent, UserBaseState> {
  UserBaseBloc() : super(UserBaseState(userData: UserModel.emptyModel)) {
    on<UpdateUserEvent>(_onUpdateUser);
  }
  _onUpdateUser(UpdateUserEvent event , Emitter<UserBaseState>emit){
    emit(state.copyWith(userData: event.userModel));
  }
}
