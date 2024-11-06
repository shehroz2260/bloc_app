import 'package:chat_with_bloc/repos/filter_repo.dart';
import 'package:chat_with_bloc/repos/get_all_users.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/filter_model.dart';
import '../../model/user_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(userList: [], isLoading: false)) {
    on<ONINITEvent>(_onInitEvent);
    on<RemoveUserFromList>(_onRemoveUSerFromList);
    on<LikeUser>(_onLikeUser);
    on<DisLikeUser>(_onDisLikeUser);
  }

  _onInitEvent(ONINITEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(userList: [], isLoading: true));
    final userList = await GetAllUsers.getAllUser();
    final filterModel = await FilterRepo.getFilter();
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
}
