// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:chat_with_bloc/model/user_model.dart';

abstract class MapEvent {}

class HideWidgetEvent extends MapEvent {}

class ShowWidgetEvent extends MapEvent {}

class OnMapCreatedEvent extends MapEvent {
  final GoogleMapController googleMapController;
  OnMapCreatedEvent({required this.googleMapController});
}

class FetchCurrentLocation extends MapEvent {
  final BuildContext context;
  FetchCurrentLocation({required this.context});
}

class SetPlacesMarker extends MapEvent {
  final BuildContext context;
  SetPlacesMarker({required this.context});
}

class AddMarkerEvent extends MapEvent {
  final Set<Marker> myMarker;
  AddMarkerEvent({required this.myMarker});
}

class OnTAPMarkerEvent extends MapEvent {
  final UserModel user;
  OnTAPMarkerEvent({
    required this.user,
  });
}
