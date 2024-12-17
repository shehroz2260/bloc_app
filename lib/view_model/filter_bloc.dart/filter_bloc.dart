import 'package:chat_with_bloc/model/filter_model.dart';
import 'package:chat_with_bloc/repos/filter_repo.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../view/account_creation_view/location_view.dart';
import '../home_bloc/home_event.dart';
import 'filter_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc()
      : super(FilterState(
            radius: 100,
            gender: 0,
            maxAge: 0,
            minAge: 0,
            filterModel: FilterModel(
                distance: 100, intrestedIn: 0, maxAge: 0, minAge: 0))) {
    on<ONChangedAges>(_onChangedAge);
    on<ONInitEvent>(_oninit);
    on<OnAppLyFilter>(_onApplyFilter);
    on<OnChangeRadisus>(_onChangeDistance);
    on<OnChangedGender>(_onChangeGender);
  }

  _onChangedAge(ONChangedAges event, Emitter<FilterState> emit) {
    final min = event.onChanged.start;
    final max = event.onChanged.end;
    emit(state.copyWith(maxAge: max, minAge: min));
  }

  _oninit(ONInitEvent event, Emitter<FilterState> emit) async {
    final model = await FilterRepo.getFilter();
    emit(state.copyWith(
        maxAge: model.maxAge,
        minAge: model.minAge,
        gender: model.intrestedIn,
        radius: model.distance));
  }

  _onChangeGender(OnChangedGender event, Emitter<FilterState> emit) {
    emit(state.copyWith(gender: event.gender));
  }

  _onChangeDistance(OnChangeRadisus event, Emitter<FilterState> emit) async {
    await Future.wait([
      Permission.location.isGranted,
      Permission.locationWhenInUse.serviceStatus
    ]).then((e) {
      var isLocationGranted = e[0] as bool;
      var serviceStatus = e[1] as ServiceStatus;
      if (!isLocationGranted || !serviceStatus.isEnabled) {
        Go.offAll(event.context, const LocationPermissionScreen());
      }
    });
    emit(state.copyWith(radius: event.value.toInt()));
  }

  _onApplyFilter(OnAppLyFilter event, Emitter<FilterState> emit) async {
    LoadingDialog.showProgress(event.context);
    FilterModel filterModel = FilterModel(
        minAge: state.minAge.toInt(),
        maxAge: state.maxAge.toInt(),
        intrestedIn: state.gender,
        distance: state.radius);
    await FilterRepo.setFilter(filterModel, event.context);
    event.context
        .read<HomeBloc>()
        .add(ONINITEvent(context: event.context, userBaseBloc: event.userBloc));
    LoadingDialog.hideProgress(event.context);
    Go.back(event.context);
  }
}
