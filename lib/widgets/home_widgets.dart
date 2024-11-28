import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../src/app_colors.dart';
import '../src/app_text_style.dart';
import '../view_model/filter_bloc.dart/filter_bloc.dart';
import '../view_model/filter_bloc.dart/filter_event.dart';
import '../view_model/filter_bloc.dart/filter_state.dart';

class InterestedInWidget extends StatefulWidget {
  const InterestedInWidget({
    super.key,
  });

  @override
  State<InterestedInWidget> createState() => _InterestedInWidgetState();
}

class _InterestedInWidgetState extends State<InterestedInWidget> {
  @override
  void initState() {
    context.read<FilterBloc>().add(ONInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(builder: (context, state) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<FilterBloc>().add(OnChangedGender(gender: 1));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: state.gender == 1 ? AppColors.redColor : null,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25)),
                    border: Border(
                      bottom: BorderSide(color: AppColors.borderGreyColor),
                      top: BorderSide(color: AppColors.borderGreyColor),
                      left: BorderSide(color: AppColors.borderGreyColor),
                    )),
                padding: const EdgeInsets.symmetric(vertical: 18),
                alignment: Alignment.center,
                child: Text(AppLocalizations.of(context)!.men,
                    style: AppTextStyle.font16.copyWith(
                        color: state.gender == 1
                            ? AppColors.whiteColor
                            : AppColors.redColor)),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<FilterBloc>().add(OnChangedGender(gender: 2));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: state.gender == 2 ? AppColors.redColor : null,
                    border: Border(
                      bottom: BorderSide(color: AppColors.borderGreyColor),
                      top: BorderSide(color: AppColors.borderGreyColor),
                    )),
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: state.gender == 2
                                    ? AppColors.redColor
                                    : AppColors.borderGreyColor),
                            right: BorderSide(
                                color: state.gender == 2
                                    ? AppColors.redColor
                                    : AppColors.borderGreyColor))),
                    child: Text(AppLocalizations.of(context)!.women,
                        style: AppTextStyle.font16.copyWith(
                            color: state.gender == 2
                                ? AppColors.whiteColor
                                : AppColors.redColor))),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<FilterBloc>().add(OnChangedGender(gender: 0));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: state.gender == 0 ? AppColors.redColor : null,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25)),
                    border: Border(
                      bottom: BorderSide(color: AppColors.borderGreyColor),
                      top: BorderSide(color: AppColors.borderGreyColor),
                      right: BorderSide(color: AppColors.borderGreyColor),
                    )),
                padding: const EdgeInsets.symmetric(vertical: 18),
                alignment: Alignment.center,
                child: Text(AppLocalizations.of(context)!.both,
                    style: AppTextStyle.font16.copyWith(
                        color: state.gender == 0
                            ? AppColors.whiteColor
                            : AppColors.redColor)),
              ),
            ),
          )
        ],
      );
    });
  }
}

class WidgetForLikeorDislike extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  final String? svgICon;
  const WidgetForLikeorDislike({
    super.key,
    required this.icon,
    required this.onTap,
    this.svgICon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        // margin:  const EdgeInsets.only(right: 15,bottom: 15),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.redColor, width: 2),
            shape: BoxShape.circle),
        child: svgICon == null
            ? Icon(icon, color: AppColors.redColor)
            : SvgPicture.asset(svgICon ?? ""),
      ),
    );
  }
}
