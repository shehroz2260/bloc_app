import 'package:chat_with_bloc/model/filter_model.dart';
import 'package:chat_with_bloc/repos/filter_repo.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_bloc.dart';
import '../home_bloc/home_event.dart';
import 'filter_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterState(radius: 0,gender: 0, maxAge: 0,minAge: 0,filterModel: FilterModel(distance: 50,intrestedIn: 0,maxAge: 0,minAge: 0))) {
    on<ONChangedAges>(_onChangedAge);
    on<ONInitEvent>(_oninit);
    on<OnAppLyFilter>(_onApplyFilter);
    on<OnChangedGender>(_onChangeGender);
  }

  _onChangedAge(ONChangedAges event , Emitter<FilterState>emit){
    final min = event.onChanged.start;
    final max = event.onChanged.end;
    emit(state.copyWith(maxAge: max,minAge: min));
  }

  _oninit(ONInitEvent event , Emitter<FilterState>emit)async{
    final model = await FilterRepo.getFilter();
    emit(state.copyWith(maxAge: model.maxAge, minAge: model.minAge,gender: model.intrestedIn,radius: model.distance));
  }

  _onChangeGender(OnChangedGender event, Emitter<FilterState>emit){

    emit(state.copyWith(gender: event.gender));
  }

  _onApplyFilter(OnAppLyFilter event ,Emitter<FilterState>emit)async{
    LoadingDialog.showProgress(event.context);
   FilterModel filterModel = FilterModel(minAge: state.minAge.toInt(), maxAge: state.maxAge.toInt(), intrestedIn: state.gender, distance: state.radius);
await  FilterRepo.setFilter(filterModel, event.context);
event.context.read<HomeBloc>().add(ONINITEvent());
    LoadingDialog.hideProgress(event.context);
Go.back(event.context);
  }
}
