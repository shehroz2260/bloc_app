import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/repos/filter_repo.dart';
import 'package:chat_with_bloc/repos/get_all_users.dart';
import '../../model/filter_model.dart';
import '../../model/user_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(userList: [],isLoading: false)) {
    on<ONINITEvent>(_onInitEvent);
    on<RemoveUserFromList>(_onRemoveUSerFromList);
  }

  _onInitEvent(ONINITEvent event, Emitter<HomeState>emit)async{
    emit(state.copyWith(userList: [],isLoading: true));
    final userList = await GetAllUsers.getAllUser();
    final filterModel = await FilterRepo.getFilter();
    await emit.forEach(Stream.fromIterable(userList), onData: (value){
       final isUSerMatch = applyFilter(value, filterModel);
       if(!isUSerMatch)return state;
       state.userList.add(value);
       return state.copyWith(userList: state.userList);
    });
    emit(state.copyWith(isLoading: false));
  }

    bool applyFilter(UserModel user, FilterModel userFilter) {
      bool genderCondition = (userFilter.intrestedIn == 0 || userFilter.intrestedIn == user.gender);
       bool ageCondition = (userFilter.maxAge == 100)
        ? userFilter.minAge <= user.age
        : (userFilter.minAge <= user.age && userFilter.maxAge >= user.age);
    return ageCondition && genderCondition;
  }

_onRemoveUSerFromList (RemoveUserFromList event , Emitter<HomeState>emit){
  state.userList.remove(event.userModel);
emit(state.copyWith(userList: state.userList));
}
}
