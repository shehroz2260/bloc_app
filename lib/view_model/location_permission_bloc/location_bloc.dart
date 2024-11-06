import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/utils/permission_utils.dart';
import 'package:chat_with_bloc/view/account_creation_view/welcome_view.dart';
import 'package:chat_with_bloc/view/main_view/main_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState()) {
    on<OnRequestPermissionEvent>(_onRequestPermission);
  }

  Position? position;
  Future<Position> determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position?.latitude ?? 30.8196376, position?.longitude ?? 73.4308561);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        return '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      } else {
        return 'No address found';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  _onRequestPermission(
      OnRequestPermissionEvent event, Emitter<LocationState> emit) async {
    if (!await PermissionUtils(
            context: event.context,
            permission: Permission.locationWhenInUse,
            permissionName: "Location")
        .isAllowed) {
      return;
    }
    if (!await Geolocator.isLocationServiceEnabled()) {
      var result = await showOkCancelAlertDialog(
          context: event.context,
          title: "Location",
          message: "Please Enable location",
          okLabel: "Open setting",
          cancelLabel: "Later");

      if (result == OkCancelResult.ok) {
        await Geolocator.openLocationSettings();
      }
      return;
    }

    LoadingDialog.showProgress(event.context);
    position = await determinePosition();
    String address = await getAddressFromLatLng();

    try {
      var userModel =
          BlocProvider.of<UserBaseBloc>(event.context).state.userData;
      userModel = userModel.copyWith(
          lat: position?.latitude ?? 0.0,
          lng: position?.longitude ?? 0.0,
          location: address);
      event.context
          .read<UserBaseBloc>()
          .add(UpdateUserEvent(userModel: userModel));
      NetworkService.updateUser(userModel);

      LoadingDialog.hideProgress(event.context);
      if (event.isFromOnboard) {
        Go.offAll(event.context, const WelcomeView());
      } else {
        Go.offAll(event.context, const MainView());
      }
    } on FirebaseException catch (e) {
      LoadingDialog.hideProgress(event.context);
      showOkAlertDialog(
          context: event.context, message: e.message, title: "Error");
    }
  }
}
