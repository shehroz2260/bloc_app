import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/preference_bloc/preference_bloc.dart';
import 'package:chat_with_bloc/view_model/preference_bloc/preference_state.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/preference_bloc/preference_event.dart';

class PreferenceView extends StatefulWidget {
  const PreferenceView({super.key});

  @override
  State<PreferenceView> createState() => _PreferenceViewState();
}

class _PreferenceViewState extends State<PreferenceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<PreferenceBloc, PreferenceState>(
          builder: (context, state) {
            return Column(
              children: [
                const AppHeight(height: 50),
                Text(AppStrings.preferences, style: AppTextStyle.font25),
                const AppHeight(height: 40),
                CustomButton(
                  onTap: () {
                    context.read<PreferenceBloc>().add(PickGenders(gender: 0));
                  },
                  btnName: AppStrings.both,
                  color: state.prefGenders ==0? AppColors.blueColor: AppColors.whiteColor,
                  textColor:state.prefGenders ==0?AppColors.blackColor: AppColors.blackColor,
                ),
                const AppHeight(height: 20),
                CustomButton(
                  onTap: () {
                    context.read<PreferenceBloc>().add(PickGenders(gender: 1));
                  },
                    btnName: AppStrings.men,
                    color: state.prefGenders ==1? AppColors.blueColor: AppColors.whiteColor,
                  textColor:state.prefGenders ==1?AppColors.blackColor: AppColors.blackColor,),
                const AppHeight(height: 20),
                CustomButton(
                  onTap: () {
                    context.read<PreferenceBloc>().add(PickGenders(gender: 2));
                  },
                    btnName: AppStrings.women,
                    color: state.prefGenders ==2? AppColors.blueColor: AppColors.whiteColor,
                  textColor:state.prefGenders ==2?AppColors.blackColor: AppColors.blackColor,),
                const AppHeight(height: 40),
                 CustomButton(btnName: AppStrings.next,onTap: () {
                   context.read<PreferenceBloc>().add(OnNextEvent(context: context));
                 },),
              ],
            );
          },
        ),
      ),
    );
  }
}
