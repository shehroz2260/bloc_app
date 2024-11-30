import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/view/account_creation_view/location_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/loading_dialog.dart';
import 'bio_event.dart';
import 'bio_state.dart';

class BioBloc extends Bloc<BioEvent, BioState> {
  BioBloc() : super(BioState()) {
    on<OnContinue>(_onContinue);
  }

  _onContinue(OnContinue event, Emitter<BioState> emit) async {
    LoadingDialog.showProgress(event.context);
    var user = event.context.read<UserBaseBloc>().state.userData;
    user = user.copyWith(
        bio: event.bioController.text, about: event.aboutController.text);
    NetworkService.updateUser(user);
    event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
    await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .where("isAdmin", isEqualTo: true)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (final e in value.docs) {
          final model = UserModel.fromMap(e.data());
          await NetworkService.createNewThread(
              event.context.read<UserBaseBloc>().state.userData,
              model,
              true,
              null);
        }
      }
    });
    LoadingDialog.hideProgress(event.context);
    Go.offAll(
        event.context, const LocationPermissionScreen(isFromOnboard: true));
    event.aboutController.clear();
    event.bioController.clear();
  }
}
