// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../model/user_model.dart';

class MapState {
  final bool isLoading;
  final bool showWidget;
  final Set<Marker> markers;
  final UserModel selectedUser;
  final List<UserModel> resultList;
  final Position? currentPosition;
  final CameraPosition googlePlex;
  final GoogleMapController? googleMapController;
  final String address;
  MapState({
    this.googleMapController,
    required this.isLoading,
    required this.showWidget,
    required this.markers,
    required this.selectedUser,
    required this.resultList,
    this.currentPosition,
    required this.googlePlex,
    required this.address,
  });

  MapState copyWith({
    bool? isLoading,
    bool? showWidget,
    Set<Marker>? markers,
    UserModel? selectedUser,
    List<UserModel>? resultList,
    Position? currentPosition,
    CameraPosition? googlePlex,
    GoogleMapController? googleMapController,
    String? address,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      showWidget: showWidget ?? this.showWidget,
      markers: markers ?? this.markers,
      selectedUser: selectedUser ?? this.selectedUser,
      resultList: resultList ?? this.resultList,
      currentPosition: currentPosition ?? this.currentPosition,
      googlePlex: googlePlex ?? this.googlePlex,
      googleMapController: googleMapController ?? this.googleMapController,
      address: address ?? this.address,
    );
  }
}
