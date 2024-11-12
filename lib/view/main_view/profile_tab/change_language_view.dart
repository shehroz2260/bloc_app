import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/change_language/change_language_bloc.dart';
import 'package:chat_with_bloc/view_model/change_language/change_language_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../src/app_text_style.dart';
import '../../../view_model/change_language/change_language_event.dart';
import '../../../widgets/custom_button.dart';

class ChangeLanguageView extends StatelessWidget {
  const ChangeLanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<ChangeLanguageBloc, ChangeLanguageState>(
              builder: (context, state) {
            return Column(
              children: [
                const AppHeight(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(),
                    Text("Change Languages",
                        style: AppTextStyle.font25
                            .copyWith(color: AppColors.blackColor)),
                    const SizedBox(
                      width: 55,
                    )
                  ],
                ),
                const AppHeight(height: 20),
                GestureDetector(
                  onTap: () {
                    context
                        .read<ChangeLanguageBloc>()
                        .add(ChnageLocale(code: "en"));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: state.locale.languageCode == "en" ? 2 : 1,
                          color: state.locale.languageCode == "en"
                              ? AppColors.redColor
                              : AppColors.borderGreyColor,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            "assets/images/png/USA.png",
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const AppWidth(width: 20),
                        Text(
                          "English",
                          style: AppTextStyle.font20.copyWith(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                const AppHeight(height: 20),
                GestureDetector(
                  onTap: () {
                    context
                        .read<ChangeLanguageBloc>()
                        .add(ChnageLocale(code: "ur"));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: state.locale.languageCode == "ur" ? 2 : 1,
                          color: state.locale.languageCode == "ur"
                              ? AppColors.redColor
                              : AppColors.borderGreyColor,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            "assets/images/png/images (2).jpg",
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const AppWidth(width: 20),
                        Text(
                          "Urdu",
                          style: AppTextStyle.font20.copyWith(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
