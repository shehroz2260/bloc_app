import 'package:chat_with_bloc/services/local_storage_service.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/on_boarding_view/on_boarding_screen.dart';
import 'package:chat_with_bloc/view_model/language_from_onbo_bloc/language_from_onbo_bloc.dart';
import 'package:chat_with_bloc/view_model/language_from_onbo_bloc/language_from_onbo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/language_from_onbo_bloc/language_from_onbo_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageFromOnboarding extends StatelessWidget {
  const LanguageFromOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: BlocBuilder<LanguageFromOnboBloc, LanguageFromOnboState>(
          builder: (context, state) {
        return Column(
          children: [
            SafeArea(
              child: Material(
                elevation: 5,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(color: AppColors.borderGreyColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.selectLanguage,
                        style: TextStyle(
                            color: theme.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      if (state.currentIndex != -1)
                        GestureDetector(
                          onTap: () {
                            LocalStorageService.storage.write(
                                LocalStorageService.forLanguageVisitedScreen,
                                true);
                            Go.offAll(context, const OnBoardingScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.redColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            child: Text(
                              "Select",
                              style: TextStyle(
                                  color: AppColors.whiteColor, fontSize: 16),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const AppHeight(height: 20),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(_languages.length, (index) {
                      return GestureDetector(
                        onTap: () => context.read<LanguageFromOnboBloc>().add(
                            UdateLanguage(
                                index: index,
                                context: context,
                                code: _codes[index])),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _languages[index],
                                    style: TextStyle(
                                        color: theme.textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: state.currentIndex == index
                                                ? AppColors.redColor
                                                : AppColors.blackColor,
                                            width: 2)),
                                    padding: const EdgeInsets.all(2.5),
                                    child: state.currentIndex == index
                                        ? Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: AppColors.redColor,
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        : const SizedBox(),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: AppColors.borderGreyColor,
                            )
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
            ))
          ],
        );
      }),
    );
  }
}

List<String> _languages = [
  "English(Us)",
  "Urdu(PK)",
];

List<String> _codes = [
  "en",
  "ur",
];
