import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../src/app_colors.dart';
import '../src/app_text_style.dart';
import '../src/width_hieght.dart';
import '../view_model/filter_bloc.dart/filter_bloc.dart';
import '../view_model/filter_bloc.dart/filter_event.dart';
import '../view_model/filter_bloc.dart/filter_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/home_widgets.dart';

class CustomDialogs {
  static void openFilterDialog(
      BuildContext context, UserBaseBloc ancestorContext) async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppHeight(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.clear,
                            style: AppTextStyle.font20.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold)),
                        Text(AppLocalizations.of(context)!.filter,
                            style: AppTextStyle.font20.copyWith(
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.bold)),
                        GestureDetector(
                            onTap: () {
                              context
                                  .read<FilterBloc>()
                                  .add(OnChangedGender(gender: 0));
                              context.read<FilterBloc>().add(ONChangedAges(
                                  onChanged: const SfRangeValues(18, 50),
                                  context: context));
                              context.read<FilterBloc>().add(OnChangeRadisus(
                                  value: 100, context: context));
                            },
                            child: Text(AppLocalizations.of(context)!.clear,
                                style: AppTextStyle.font20.copyWith(
                                    color: AppColors.redColor,
                                    fontWeight: FontWeight.bold)))
                      ],
                    ),
                    const AppHeight(height: 30),
                    Text(AppLocalizations.of(context)!.showMe,
                        style: AppTextStyle.font20.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold)),
                    const AppHeight(height: 15),
                    const InterestedInWidget(),
                    const AppHeight(height: 30),
                    Row(
                      children: [
                        Expanded(
                            child: Text(AppLocalizations.of(context)!.age,
                                style: AppTextStyle.font20.copyWith(
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold))),
                        Text(
                          "${state.minAge.toInt()} - ",
                          style: AppTextStyle.font16.copyWith(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                            state.maxAge == 100
                                ? AppLocalizations.of(context)!.all
                                : state.maxAge.toInt().toString(),
                            style: AppTextStyle.font16.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackColor)),
                        const AppWidth(width: 20)
                      ],
                    ),
                    const AppHeight(height: 10),
                    SfRangeSliderTheme(
                      data: SfRangeSliderThemeData(
                          overlayColor: Colors.transparent,
                          activeTrackHeight: 10,
                          inactiveTrackHeight: 10,
                          inactiveTrackColor:
                              AppColors.redColor.withOpacity(.5),
                          activeTrackColor: AppColors.redColor,
                          thumbRadius: 16,
                          thumbStrokeWidth: 1.5,
                          thumbStrokeColor: AppColors.whiteColor,
                          thumbColor: AppColors.whiteColor),
                      child: SfRangeSlider(
                        values: SfRangeValues(
                            state.minAge.toDouble(), state.maxAge.toDouble()),
                        onChanged: (value) => context.read<FilterBloc>().add(
                            ONChangedAges(onChanged: value, context: context)),
                        max: 100,
                        min: 18,
                        startThumbIcon: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.whiteColor),
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.redColor),
                          ),
                        ),
                        endThumbIcon: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.whiteColor),
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.redColor),
                          ),
                        ),
                      ),
                    ),
                    const AppHeight(height: 30),
                    Row(
                      children: [
                        Expanded(
                            child: Text(AppLocalizations.of(context)!.distance,
                                style: AppTextStyle.font20.copyWith(
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold))),
                        Text(
                            state.radius == 100
                                ? AppLocalizations.of(context)!.all
                                : state.radius.toInt().toString(),
                            style: AppTextStyle.font16.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackColor)),
                        const AppWidth(width: 20)
                      ],
                    ),
                    const AppHeight(height: 10),
                    SfSliderTheme(
                      data: const SfSliderThemeData(
                          thumbRadius: 16,
                          activeTrackHeight: 10,
                          inactiveTrackHeight: 10),
                      child: SfSlider(
                        activeColor: AppColors.redColor,
                        inactiveColor: AppColors.redColor.withOpacity(.5),
                        value: state.radius,
                        onChanged: (value) => context.read<FilterBloc>().add(
                            OnChangeRadisus(value: value, context: context)),
                        max: 100,
                        thumbIcon: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.whiteColor),
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.redColor),
                          ),
                        ),
                      ),
                    ),
                    const AppHeight(height: 30),
                    CustomNewButton(
                        btnName: AppLocalizations.of(context)!.apply,
                        onTap: () {
                          context.read<FilterBloc>().add(OnAppLyFilter(
                              context: context, userBloc: ancestorContext));
                        })
                  ],
                );
              }),
            ),
          );
        });
  }
}
