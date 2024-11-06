import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/location_permission_bloc/location_bloc.dart';
import '../../view_model/location_permission_bloc/location_event.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const SizedBox(height: 30),
              const Text(
                "Location permissions is required for This App",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  onTap: () => context
                      .read<LocationBloc>()
                      .add(OnRequestPermissionEvent(context: context)),
                  btnName: 'Enable Location',
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
