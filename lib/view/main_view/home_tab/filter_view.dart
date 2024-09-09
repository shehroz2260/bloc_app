import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/filter_bloc.dart/filter_bloc.dart';
import 'package:chat_with_bloc/view_model/filter_bloc.dart/filter_event.dart';
import 'package:chat_with_bloc/view_model/filter_bloc.dart/filter_state.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  @override
  void initState() {
  context.read<FilterBloc>().add(ONInitEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: BlocBuilder<FilterBloc, FilterState>(
        builder: (context,state) {
          return Column(
            children: [
              const AppHeight(height: 50),
              Text(AppStrings.filter,style: AppTextStyle.font25),
              const AppHeight(height: 30),
               CustomButton(onTap: () {
                 context.read<FilterBloc>().add(OnChangedGender(gender: 0));
               } ,btnName: "Both",color: state.gender == 0? AppColors.blueColor:AppColors.whiteColor,textColor: state.gender == 0? AppColors.whiteColor: AppColors.blackColor),
              const AppHeight(height: 20),
               CustomButton(onTap: () {
                 context.read<FilterBloc>().add(OnChangedGender(gender: 1));
               } ,btnName: "Men",color: state.gender == 1? AppColors.blueColor:AppColors.whiteColor,textColor: state.gender == 1? AppColors.whiteColor: AppColors.blackColor),
              const AppHeight(height: 20),
               CustomButton(onTap: () {
                 context.read<FilterBloc>().add(OnChangedGender(gender: 2));
               } ,btnName: "Women",color: state.gender == 2? AppColors.blueColor:AppColors.whiteColor,textColor: state.gender == 2? AppColors.whiteColor: AppColors.blackColor),
              const AppHeight(height: 20),
                SfRangeSliderTheme(
                            data: SfRangeSliderThemeData(
                                overlayColor: Colors.transparent,
                                activeTrackHeight: 2,
                                inactiveTrackHeight: 2,
                                inactiveTrackColor:
                                    AppColors.blueColor.withOpacity(.5),
                                activeTrackColor: AppColors.blueColor,
                                thumbRadius: 16,
                                thumbStrokeWidth: 1.5,
                                thumbStrokeColor: AppColors.blueColor,
                                thumbColor: AppColors.whiteColor),
                            child: SfRangeSlider(
                              values: SfRangeValues(state.minAge.toDouble(),
                                  state.maxAge.toDouble()),
                              onChanged: (value)=> context.read<FilterBloc>().add(ONChangedAges(onChanged: value)),
                              max: 100,
                              min: 18,
                              startThumbIcon: Center(
                                  child: Text(
                                state.minAge.toInt().toString(),
                                style:  TextStyle(
                                    fontSize: 14,
                                    color: AppColors.blueColor),
                              )),
                              endThumbIcon: Center(
                                child: Text(
                                 state.maxAge == 100? "100+": state.maxAge.toInt().toString(),
                                  style:  TextStyle(
                                      fontSize:state.maxAge == 100?11: 14,
                                      color: AppColors.blueColor),
                                ),
                              ),
                            ),
                          ),
                          const AppHeight(height: 30),
               CustomButton(btnName: "Apply",onTap: () {
                context.read<FilterBloc>().add(OnAppLyFilter(context: context));
              },),
          
            ],
          );
        }
      ),
    );
  }
}