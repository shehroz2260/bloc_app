import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/gender_bloc/gender_bloc.dart';
import 'package:chat_with_bloc/view_model/gender_bloc/gender_event.dart';
import 'package:chat_with_bloc/view_model/gender_bloc/gender_state.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenderView extends StatefulWidget {
  const GenderView({super.key});

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<GenderBloc, GenderState>(
          builder: (context, state) {
            return Column(
              children: [
                const AppHeight(height: 50),
                Text(AppStrings.gender, style: AppTextStyle.font25),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    context.read<GenderBloc>().add(PickGender(gender: 1));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color:state.gender == 1? AppColors.blueColor: AppColors.whiteColor),
                    padding: const EdgeInsets.all(50),
                    child: SvgPicture.asset(AppAssets.maleIcon,colorFilter: ColorFilter.mode(state.gender == 1? AppColors.whiteColor: AppColors.blackColor, BlendMode.srcIn),),
                  ),
                ),
                const AppHeight(height: 10),
                Text(AppStrings.male, style: AppTextStyle.font25),
                const AppHeight(height: 30),
                GestureDetector(
                  onTap: () {
                       context.read<GenderBloc>().add(PickGender(gender: 2));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: state.gender == 2? AppColors.blueColor: AppColors.whiteColor),
                    padding: const EdgeInsets.all(50),
                    child: SvgPicture.asset(AppAssets.femaleIcon,colorFilter: ColorFilter.mode(state.gender == 2? AppColors.whiteColor: AppColors.blackColor, BlendMode.srcIn)),
                  ),
                ),
                const AppHeight(height: 10),
                Text(AppStrings.female, style: AppTextStyle.font25),
                const Expanded(child: SizedBox()),
                 CustomButton(btnName: AppStrings.next,onTap: () {
                   context.read<GenderBloc>().add(OnNextEvent(context: context));
                 },),
                const AppHeight(height: 30)
              ],
            );
          },
        ),
      ),
    );
  }
}
