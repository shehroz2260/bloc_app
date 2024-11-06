import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/location_permission_bloc/location_bloc.dart';
import '../../view_model/location_permission_bloc/location_event.dart';

class LocationPermissionScreen extends StatelessWidget {
  final bool isFromOnboard;
  const LocationPermissionScreen({super.key, this.isFromOnboard = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("assets/images/png/pngwing 3.png"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset("assets/images/png/address (1).png"),
          ),
          const AppHeight(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Need your location",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: AppColors.redColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Please give us access to your Gps Location for better experience to see user nearby you.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomNewButton(
              onTap: () => context.read<LocationBloc>().add(
                  OnRequestPermissionEvent(
                      context: context, isFromOnboard: isFromOnboard)),
              btnName: 'Enable Location',
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
