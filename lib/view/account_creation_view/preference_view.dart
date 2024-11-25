// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/preference_bloc/preference_bloc.dart';
import 'package:chat_with_bloc/view_model/preference_bloc/preference_state.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter_svg/svg.dart';
import '../../view_model/preference_bloc/preference_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreferenceView extends StatefulWidget {
  final bool isUpdate;
  const PreferenceView({super.key, this.isUpdate = false});

  @override
  State<PreferenceView> createState() => _PreferenceViewState();
}

class _PreferenceViewState extends State<PreferenceView> {
  @override
  void initState() {
    if (widget.isUpdate) {
      context.read<PreferenceBloc>().add(OnInitEdit(context: context));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: BlocBuilder<PreferenceBloc, PreferenceState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeight(height: 60),
                const CustomBackButton(),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppHeight(height: 30),
                      if (!widget.isUpdate)
                        Text(AppLocalizations.of(context)!.preferencegender,
                            style: AppTextStyle.font25
                                .copyWith(color: theme.textColor)),
                      if (!widget.isUpdate) const AppHeight(height: 10),
                      if (!widget.isUpdate)
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<PreferenceBloc>()
                                    .add(PickGenders(gender: 0));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: state.prefGenders == 0
                                      ? AppColors.redColor
                                      : null,
                                  border: state.prefGenders == 0
                                      ? null
                                      : Border.all(
                                          color: AppColors.borderGreyColor),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text(AppLocalizations.of(context)!.both,
                                    style: AppTextStyle.font16.copyWith(
                                        color: state.prefGenders == 0
                                            ? AppColors.whiteColor
                                            : AppColors.redColor)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<PreferenceBloc>()
                                    .add(PickGenders(gender: 1));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: state.prefGenders == 1
                                      ? AppColors.redColor
                                      : null,
                                  border: state.prefGenders == 1
                                      ? null
                                      : Border.all(
                                          color: AppColors.borderGreyColor),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text(AppLocalizations.of(context)!.men,
                                    style: AppTextStyle.font16.copyWith(
                                        color: state.prefGenders == 1
                                            ? AppColors.whiteColor
                                            : AppColors.redColor)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<PreferenceBloc>()
                                    .add(PickGenders(gender: 2));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: state.prefGenders == 2
                                      ? AppColors.redColor
                                      : null,
                                  border: state.prefGenders == 2
                                      ? null
                                      : Border.all(
                                          color: AppColors.borderGreyColor),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text(AppLocalizations.of(context)!.women,
                                    style: AppTextStyle.font16.copyWith(
                                        color: state.prefGenders == 2
                                            ? AppColors.whiteColor
                                            : AppColors.redColor)),
                              ),
                            ),
                          ],
                        ),
                      if (!widget.isUpdate) const AppHeight(height: 20),
                      Text(AppLocalizations.of(context)!.yourInsterest,
                          style: AppTextStyle.font25
                              .copyWith(color: theme.textColor)),
                      const AppHeight(height: 5),
                      Text(
                          AppLocalizations.of(context)!.selectAFewfyourinstrest,
                          style: AppTextStyle.font16
                              .copyWith(color: theme.textColor)),
                      const AppHeight(height: 20),
                      GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3.4,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: interestList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<PreferenceBloc>()
                                    .add(SelectInstrest(index: index));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                    color: state.intrestList.contains(index)
                                        ? AppColors.redColor
                                        : null,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: state.intrestList.contains(index)
                                            ? AppColors.redColor
                                            : AppColors.borderGreyColor)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(interestList[index].icon,
                                        colorFilter: ColorFilter.mode(
                                            state.intrestList.contains(index)
                                                ? AppColors.whiteColor
                                                : AppColors.redColor,
                                            BlendMode.srcIn)),
                                    const AppWidth(width: 10),
                                    Text(interestList[index].name,
                                        style: AppTextStyle.font16.copyWith(
                                            fontSize: 14,
                                            color: state.intrestList
                                                    .contains(index)
                                                ? AppColors.whiteColor
                                                : theme.textColor))
                                  ],
                                ),
                              ),
                            );
                          }),
                      const AppHeight(height: 20),
                      CustomNewButton(
                        btnName: widget.isUpdate
                            ? AppLocalizations.of(context)!.update
                            : AppLocalizations.of(context)!.next,
                        onTap: () {
                          context.read<PreferenceBloc>().add(OnNextEvent(
                              context: context, isUpdate: widget.isUpdate));
                        },
                      ),
                      const AppHeight(height: 30),
                    ],
                  ),
                )),
              ],
            );
          },
        ),
      ),
    );
  }
}

List<InsterestModel> interestList = [
  InsterestModel(name: AppStrings.photography, icon: AppAssets.photoGraphy),
  InsterestModel(name: AppStrings.shopping, icon: AppAssets.shopping),
  InsterestModel(name: AppStrings.voice, icon: AppAssets.voice),
  InsterestModel(name: AppStrings.yoga, icon: AppAssets.yoga),
  InsterestModel(name: AppStrings.cooking, icon: AppAssets.cooking),
  InsterestModel(name: AppStrings.tennis, icon: AppAssets.tennis),
  InsterestModel(name: AppStrings.run, icon: AppAssets.run),
  InsterestModel(name: AppStrings.swimming, icon: AppAssets.swimming),
  InsterestModel(name: AppStrings.art, icon: AppAssets.art),
  InsterestModel(name: AppStrings.traveling, icon: AppAssets.traveling),
  InsterestModel(name: AppStrings.extreme, icon: AppAssets.extreme),
  InsterestModel(name: AppStrings.music, icon: AppAssets.music),
  InsterestModel(name: AppStrings.drink, icon: AppAssets.drink),
  InsterestModel(name: AppStrings.videoGames, icon: AppAssets.videoGame),
];

class InsterestModel {
  final String name;
  final String icon;
  InsterestModel({
    required this.name,
    required this.icon,
  });
}
