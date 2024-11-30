import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/model/thread_model.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/network_service.dart';
import 'contact_us_event.dart';
import 'contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  ContactUsBloc()
      : super(ContactUsState(
          adminThreadList: [],
        )) {
    on<OninintContactus>(_oninContactUS);
    on<OnDisposeContact>(_onDisposeContactUS);
  }

  _oninContactUS(OninintContactus event, Emitter<ContactUsState> emit) async {
    LoadingDialog.showProgress(event.context);
    await FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .where("participantUserList",
            arrayContains: FirebaseAuth.instance.currentUser?.uid ?? "")
        .where("isAdmin", isEqualTo: true)
        .get()
        .then((val) async {
      if (val.docs.isEmpty) return;
      for (final e in val.docs) {
        var chat = ThreadModel.fromMap(e.data());
        var userModel = await NetworkService.getUserDetailById(
            chat.participantUserList[0] ==
                    (FirebaseAuth.instance.currentUser?.uid ?? "")
                ? chat.participantUserList[1]
                : chat.participantUserList[0]);
        chat.userDetail = userModel;
        state.adminThreadList.add(chat);
        emit(state.copyWith(adminThreadList: state.adminThreadList));
      }
    });
    LoadingDialog.hideProgress(event.context);
  }

  _onDisposeContactUS(
      OnDisposeContact event, Emitter<ContactUsState> emit) async {
    emit(state.copyWith(adminThreadList: []));
  }
}
