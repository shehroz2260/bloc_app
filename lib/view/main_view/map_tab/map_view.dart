// ignore_for_file: deprecated_member_use
// import 'package:chat_with_bloc/src/go_file.dart';
// import 'package:chat_with_bloc/widgets/show_user_on_map_widget.dart';
// import 'package:chat_with_bloc/widgets/user_detail_widget.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../src/map_theme.dart';
// import '../../../view_model/map_bloc/map_bloc.dart';
// import '../../../view_model/map_bloc/map_event.dart';
// import '../../../view_model/map_bloc/map_state.dart';

class MapScreen extends StatefulWidget {
   const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
// @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {

  //   context.read<MapBloc>().add(FetchCurrentLocation(context: context));
  //   // context.read<MapBloc>().add(SetPlacesMarker(context: context));
    
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      // body: BlocBuilder<MapBloc, MapState>(
      //   builder: (context, state) {
      //     return Column(
      //       children: [
      //         Expanded(
      //           child: Stack(
      //             children: [
      //               GoogleMap(
      //             onTap: (latLng) {
      //               FocusScope.of(context).requestFocus(FocusNode());
      //               context.read<MapBloc>().add(HideWidgetEvent());
      //             },
      //             mapToolbarEnabled: false,
      //             compassEnabled: true,
      //             rotateGesturesEnabled: true,
      //             zoomControlsEnabled: true,
      //             scrollGesturesEnabled: true,
      //             tiltGesturesEnabled: false,
      //             mapType: MapType.normal,
      //             zoomGesturesEnabled: true,
      //             myLocationButtonEnabled: false,
      //             onMapCreated: (mapController){
      //                 context.read<MapBloc>().add(OnMapCreatedEvent(googleMapController: mapController));
      //               mapController.setMapStyle(MapDarkTheme.mapStyle["dark"]);
      //             },
      //             initialCameraPosition: state.googlePlex,
      //             markers: Set.from(state.markers),
      //           ),
      //            if(state.showWidget)
      //             Positioned(
      //               bottom: 15,
      //               left: 15,
      //               right: 15,
      //               child: ShowUserOnMapWidget(
      //                   userModel: state.selectedUser,
      //                   onTap: () {
      //                     context.read<MapBloc>().add(HideWidgetEvent());
                    
      //                     Go.to(
      //                         context, ProfilePage(
      //                               user: state.selectedUser,
      //                             ),
      //                       );
      //                   },
      //                 ),
      //             )
      //             ],
      //           ),
      //         ),
      //       ],
      //     );
      //   }
      // ),
     
    );
  }
}
