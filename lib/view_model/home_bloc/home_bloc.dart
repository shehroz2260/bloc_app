import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/repos/filter_repo.dart';
import 'package:chat_with_bloc/repos/get_all_users.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/filter_model.dart';
import '../../model/report_user_model.dart';
import '../../model/user_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(userList: [], isLoading: false)) {
    on<ONINITEvent>(_onInitEvent);
    on<RemoveUserFromList>(_onRemoveUSerFromList);
    on<LikeUser>(_onLikeUser);
    on<DisLikeUser>(_onDisLikeUser);
    on<OnReportUser>(_onReportUser);
  }

  Future<List<ReportUserModel>> getReportedUser() async {
    final snapShot = await FirebaseFirestore.instance
        .collection(ReportUserModel.tableName)
        .get();
    if (snapShot.docs.isNotEmpty) {
      return snapShot.docs
          .map((e) => ReportUserModel.fromMap(e.data()))
          .toList();
    }
    return [];
  }

  _onInitEvent(ONINITEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(userList: [], isLoading: true));
    final userList = await GetAllUsers.getAllUser();
    final filterModel = await FilterRepo.getFilter();
    final reportUserList = await getReportedUser();
    UserModel cUser = UserModel.emptyModel;
    if (event.userBaseBloc == null) {
      cUser = event.context.read<UserBaseBloc>().state.userData;
    } else {
      cUser = event.userBaseBloc!.state.userData;
    }
    await emit.forEach(Stream.fromIterable(userList), onData: (value) {
      final isUSerMatch = applyFilter(value, filterModel);
      if (!isUSerMatch) return state;
      if (cUser.isDisLiked(value.uid)) {
        return state;
      }
      if (cUser.isLiked(value.uid)) {
        return state;
      }
      if (value.distance(event.context, event.userBaseBloc) >
              filterModel.distance &&
          filterModel.distance < 100) {
        return state;
      }
      final reportedUSer =
          reportUserList.where((e) => e.reportedUserId == value.uid).toList();
      if (reportedUSer.isNotEmpty &&
          reportedUSer.first.reportedUserId == value.uid) {
        return state;
      }
      state.userList.add(value);
      return state.copyWith(userList: state.userList);
    });
    emit(state.copyWith(isLoading: false));
  }

  bool applyFilter(UserModel user, FilterModel userFilter) {
    bool genderCondition =
        (userFilter.intrestedIn == 0 || userFilter.intrestedIn == user.gender);
    bool ageCondition = (userFilter.maxAge == 100)
        ? userFilter.minAge <= user.age
        : (userFilter.minAge <= user.age && userFilter.maxAge >= user.age);

    return ageCondition && genderCondition;
  }

  _onRemoveUSerFromList(RemoveUserFromList event, Emitter<HomeState> emit) {
    state.userList.remove(event.userModel);
    emit(state.copyWith(userList: state.userList));
  }

  _onLikeUser(LikeUser event, Emitter<HomeState> emit) async {
    LoadingDialog.showProgress(event.context);
    await NetworkService.likeUser(event.liker, event.likee, event.context);
    LoadingDialog.hideProgress(event.context);
    add(RemoveUserFromList(userModel: event.likee));
  }

  _onDisLikeUser(DisLikeUser event, Emitter<HomeState> emit) async {
    LoadingDialog.showProgress(event.context);
    await NetworkService.disLikeUser(event.liker, event.likee);
    LoadingDialog.hideProgress(event.context);
    add(RemoveUserFromList(userModel: event.likee));
  }

  _onReportUser(OnReportUser event, Emitter<HomeState> emit) async {
    var res = await showOkCancelAlertDialog(
        context: event.context,
        message: "Do you really want to report this user",
        title: "Are you sure",
        okLabel: "Report");
    if (res == OkCancelResult.cancel) return;
    String options =
        await NetworkService.reportUser(event.userModel, event.context, null);
    if (options.isEmpty) return;
    add(RemoveUserFromList(userModel: event.userModel));
  }
}
