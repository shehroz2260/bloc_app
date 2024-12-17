import 'package:bloc/bloc.dart';
import 'admin_nav_event.dart';
import 'admin_nav_state.dart';

class AdminNavBloc extends Bloc<AdminNavEvent, AdminNavState> {
  AdminNavBloc() : super(AdminNavState(currentIndex: 0)) {
    on<UpdateAdminNavIndex>(_onUpdateAdminNavIndex);
    on<OnDisposeNavigation>(_onDisposeNav);
  }
  _onUpdateAdminNavIndex(
      UpdateAdminNavIndex event, Emitter<AdminNavState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }

  _onDisposeNav(OnDisposeNavigation event, Emitter<AdminNavState> emit) {
    add(UpdateAdminNavIndex(index: 0));
  }
}
