import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/location_permission_bloc/location_bloc.dart';
import '../../view_model/location_permission_bloc/location_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              AppLocalizations.of(context)!.needyourlocation,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: AppColors.redColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppLocalizations.of(context)!.pleaseGiveUSAccesstoYourGps,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
              btnName: AppLocalizations.of(context)!.enableLocation,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
