import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/change_theme_bloc/change_theme_bloc.dart';
import 'package:chat_with_bloc/view_model/change_theme_bloc/change_theme_event.dart';
import 'package:chat_with_bloc/view_model/change_theme_bloc/change_theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../src/app_text_style.dart';
import '../../../widgets/custom_button.dart';

class ChangeThemeView extends StatelessWidget {
  const ChangeThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
              builder: (context, state) {
            return Column(
              children: [
                const AppHeight(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(),
                    Text(
                      AppLocalizations.of(context)!.changeTheme,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: theme.textColor,
                          fontSize: 30),
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
                const AppHeight(height: 20),
                GestureDetector(
                  onTap: () {
                    context
                        .read<ChangeThemeBloc>()
                        .add(ChangeThemeMode(theme: ThemeMode.light));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: state.currentTheme == ThemeMode.dark ? 1 : 2,
                          color: state.currentTheme == ThemeMode.dark
                              ? AppColors.borderGreyColor
                              : AppColors.redColor,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          "Light Mode",
                          style: AppTextStyle.font20.copyWith(
                              color: theme.textColor,
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
                        .read<ChangeThemeBloc>()
                        .add(ChangeThemeMode(theme: ThemeMode.dark));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: state.currentTheme == ThemeMode.dark ? 2 : 1,
                          color: state.currentTheme == ThemeMode.dark
                              ? AppColors.redColor
                              : AppColors.borderGreyColor,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          "Dark Mode",
                          style: AppTextStyle.font20.copyWith(
                              color: theme.textColor,
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
