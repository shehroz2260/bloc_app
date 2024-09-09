import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/repos/filter_repo.dart';
import 'package:chat_with_bloc/repos/get_all_users.dart';
import '../../model/filter_model.dart';
import '../../model/user_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(userList: [])) {
    on<ONINITEvent>(_onInitEvent);
  }

  _onInitEvent(ONINITEvent event, Emitter<HomeState>emit)async{
    emit(state.copyWith(userList: []));
    final userList = await GetAllUsers.getAllUser();
    final filterModel = await FilterRepo.getFilter();
    await emit.forEach(Stream.fromIterable(userList), onData: (value){
       final isUSerMatch = applyFilter(value, filterModel);
       if(!isUSerMatch)return state;
       state.userList.add(value);
       return state.copyWith(userList: state.userList);
    });
  }

    bool applyFilter(UserModel user, FilterModel userFilter) {
    return (userFilter.maxAge == 100
            ? userFilter.minAge <= user.age
            : userFilter.minAge <= user.age && userFilter.maxAge >= user.age) &&
        userFilter.intrestedIn == 0 || userFilter.intrestedIn == user.gender;
  }

}
