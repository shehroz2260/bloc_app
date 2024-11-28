import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_home_event.dart';
import 'admin_home_state.dart';

class AdminHomeBloc extends Bloc<AdminHomeEvent, AdminHomeState> {
  AdminHomeBloc()
      : super(AdminHomeState(userList: [], searchText: "", isVerify: false)) {
    on<AdminHomeInit>(_adminHomeInit);
    on<OnChangedTextField>(_onTextEditingChanged);
    on<OnChangeVerify>(_onOnChangeVerify);
  }

  _adminHomeInit(AdminHomeInit event, Emitter<AdminHomeState> emit) async {
    await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .where("isAdmin", isNotEqualTo: true)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        emit(state.copyWith(
            userList:
                value.docs.map((e) => UserModel.fromMap(e.data())).toList()));
      }
    });
  }

  _onTextEditingChanged(
      OnChangedTextField event, Emitter<AdminHomeState> emit) {
    emit(state.copyWith(searchText: event.val));
  }

  _onOnChangeVerify(OnChangeVerify event, Emitter<AdminHomeState> emit) {
    emit(state.copyWith(isVerify: event.val));
  }
}
