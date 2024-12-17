import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
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

class LikeAndDisLikeWidget extends StatelessWidget {
  final double? height;
  final String? icon;
  final bool isLike;
  const LikeAndDisLikeWidget({
    super.key,
    this.height,
    this.icon,
    this.isLike = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: height ?? 50,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 5),
                blurRadius: 4,
                spreadRadius: 1)
          ],
          shape: BoxShape.circle,
          gradient: RadialGradient(
              center: Alignment.center,
              radius: 2,
              stops: const [
                0.0,
                1.0,
                1.0,
              ],
              colors: isLike
                  ? [
                      AppColors.pinkColor,
                      AppColors.pinkColor,
                      AppColors.whiteColor,
                    ]
                  : [
                      AppColors.pinkColor.withOpacity(0.1),
                      AppColors.pinkColor.withOpacity(0.1),
                      AppColors.whiteColor,
                    ])),
      alignment: Alignment.center,
      child: (icon ?? "").isEmpty
          ? Icon(
              Icons.report,
              size: 30,
              color: AppColors.pinkColor,
            )
          : SvgPicture.asset(icon ?? ""),
    );
  }
}
