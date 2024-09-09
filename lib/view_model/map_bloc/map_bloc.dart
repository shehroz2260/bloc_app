import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/repos/get_all_users.dart';
import 'package:chat_with_bloc/view_model/map_bloc/map_event.dart';
import 'package:chat_with_bloc/view_model/map_bloc/map_state.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../src/map_helper.dart';

class MapBloc extends Bloc<MapEvent , MapState>{
Marker? myMarker;
Set<Marker> markers = {};
  MapBloc(): super (MapState(address: "",googlePlex: const CameraPosition(target: LatLng(0, 0)),isLoading: false,markers: {},resultList: [],selectedUser: UserModel.emptyModel,showWidget: false)){
    on<HideWidgetEvent>(_onHideWidget);
    on<ShowWidgetEvent>(_onShowWidget);
    on<OnMapCreatedEvent>(_onMapCreated);
    on<FetchCurrentLocation>(_onFetchCurrentLocation);
    on<SetPlacesMarker>(_onSetPlaces);
    on<OnTAPMarkerEvent>(_onTapMarker);
    on<AddMarkerEvent>(_onAddMarker);
  }



  _onHideWidget(HideWidgetEvent event , Emitter<MapState>emit){
    emit(state.copyWith(showWidget: false));
  }
  _onShowWidget(ShowWidgetEvent event , Emitter<MapState>emit){
    emit(state.copyWith(showWidget: true));
  }
    _onMapCreated(OnMapCreatedEvent event , Emitter<MapState>emit){
      GoogleMapController controller = event.googleMapController;
    emit(state.copyWith(googleMapController: controller));
  }
  
    _onFetchCurrentLocation(FetchCurrentLocation event , Emitter<MapState>emit,)async{
      final user = event.context.read<UserBaseBloc>().state.userData;
      final currentPosition = await Geolocator.getCurrentPosition();
      emit(state.copyWith(currentPosition: currentPosition));
        if (state.currentPosition != null) {
          emit(state.copyWith(googlePlex: CameraPosition(target: LatLng(state.currentPosition!.latitude, state.currentPosition!.longitude))));}
   createMyMarker( state.currentPosition!.latitude,
          state.currentPosition!.longitude, user.profileImage, user.uid,event.context);
          final address = await getAddressFromLatLng(state.currentPosition!);
          emit(state.copyWith(address: address));
          add(SetPlacesMarker(context: event.context));

    }

//////////////////////////////////////////////  ///////////////////////////////////////////////////////////////

   LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }
  LatLngBounds _bounds(Set<Marker> markers) {
    return _createBounds(markers.map((m) => m.position).toList());
  }
  _onSetPlaces(SetPlacesMarker event , Emitter<MapState>emit)async{
    emit(state.copyWith(resultList: await GetAllUsers.getAllUser()));
    emit(state.copyWith(markers: {}));
    if (myMarker != null) {
      markers.add(myMarker!);
      event.context.read<MapBloc>().add(AddMarkerEvent(myMarker: markers));
    }

   for (UserModel element in state.resultList) {
      await createPlacesMarker(element,event.context,emit);
    }
      if (state.markers.isNotEmpty) {
      state.googleMapController!
          .animateCamera(CameraUpdate.newLatLngBounds(_bounds(state.markers), 50));
    }
  }
_onAddMarker(AddMarkerEvent event , Emitter<MapState> emit){

  emit(state.copyWith(markers: event.myMarker));
}
  Future<void> createPlacesMarker(UserModel user,BuildContext context, Emitter<MapState> emit) async {
    BitmapDescriptor bitData = await MarkerHelper()
        .getMarkerIcon(user.profileImage, const Size(122.0, 120.0));
    LatLng latlng = LatLng(user.lat, user.lng);
    Marker locationMarker = Marker(
      onTap: () {
      context.read<MapBloc>().add(OnTAPMarkerEvent(user: user));
      },
      markerId: MarkerId(user.uid),
      position: latlng,
      draggable: false,
      zIndex: 2,
      flat: true,
      icon: bitData,
    );
   
    state.markers.add(locationMarker);
    emit(state.copyWith(markers: state.markers));
  }

   Future<String> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude , position.longitude );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        return
            '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
       
      } else {
        return  'No address found';
    
      }
    } catch (e) {
      return 'Error: $e';
     
    }
  }

_onTapMarker(OnTAPMarkerEvent event, Emitter<MapState>emit){
    if (
            state.selectedUser.uid == event.user.uid) {
          emit(state.copyWith(selectedUser: UserModel.emptyModel));
        add(HideWidgetEvent());
          return;
        }
      
        emit(state.copyWith(selectedUser: event.user));
         add(ShowWidgetEvent());
}
   Future<void> createMyMarker(double newLatitude, double newLongitude,
      String? markerImage, String userUid , BuildContext context) async {
    BitmapDescriptor? bitData;
    bitData= BitmapDescriptor.defaultMarker;
    bitData = await MarkerHelper()
        .getAssetMarkerIcon("assets/images/png/myLocation.png", const Size(122.0, 120.0));
    LatLng latlng = LatLng(newLatitude, newLongitude);
    Marker userMarker = Marker(
        onTap: () {
         context.read<MapBloc>().add(HideWidgetEvent());
        },
        markerId: MarkerId(userUid),
        position: latlng,
        draggable: false,
        zIndex: 2,
        flat: true,
        infoWindow: const InfoWindow(title: "My Location"),
        icon: bitData);
    // animateCameraToLocation(latlng);

    myMarker = userMarker;
    if (myMarker != null) {
      markers.add(myMarker!);
      context.read<MapBloc>().add(AddMarkerEvent(myMarker: markers));
    }
  }

}