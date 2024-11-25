// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../src/app_text_style.dart';
import '../../../widgets/custom_button.dart';

class FaqsView extends StatelessWidget {
  const FaqsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeight(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomBackButton(),
                Text(AppLocalizations.of(context)!.faqs,
                    style:
                        AppTextStyle.font25.copyWith(color: theme.textColor)),
                const SizedBox(width: 50),
              ],
            ),
            const AppHeight(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(_faqsList(context).length, (index) {
                    return FAQWidget(
                        color: _faqsList(context)[index].color,
                        count: _faqsList(context)[index].count,
                        title: _faqsList(context)[index].question,
                        desc: _faqsList(context)[index].ans);
                  }),
                ),
              ),
            ),
            const AppHeight(height: 20)
          ],
        )),
      ),
    );
  }
}

class FAQWidget extends StatelessWidget {
  final String count;
  final String title;
  final String desc;
  final Color color;
  const FAQWidget({
    super.key,
    required this.color,
    required this.count,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$count. $title",
            style: AppTextStyle.font16.copyWith(
                color: AppColors.blackColor, fontWeight: FontWeight.w700),
          ),
          Text(
            desc,
            style: AppTextStyle.font16.copyWith(
              color: AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}

List<FAqsModel> _faqsList(BuildContext context) {
  return [
    FAqsModel(
        ans: AppLocalizations.of(context)!.answer1,
        count: "1",
        color: Colors.amber.shade100,
        question: AppLocalizations.of(context)!.question1),
    FAqsModel(
        ans: AppLocalizations.of(context)!.answer2,
        count: "2",
        color: Colors.blue.shade100,
        question: AppLocalizations.of(context)!.question2),
    FAqsModel(
        ans: AppLocalizations.of(context)!.answer3,
        count: "3",
        color: Colors.green.shade100,
        question: AppLocalizations.of(context)!.question3),
    FAqsModel(
        ans: AppLocalizations.of(context)!.answer4,
        count: "4",
        color: Colors.purple.shade100,
        question: AppLocalizations.of(context)!.question4),
    FAqsModel(
        ans: AppLocalizations.of(context)!.answer5,
        count: "5",
        color: Colors.orange.shade100,
        question: AppLocalizations.of(context)!.question5),
    FAqsModel(
        ans: AppLocalizations.of(context)!.answer6,
        count: "6",
        color: Colors.red.shade100,
        question: AppLocalizations.of(context)!.question6),
    FAqsModel(
        ans: AppLocalizations.of(context)!.answer7,
        count: "7",
        color: Colors.green.shade100,
        question: AppLocalizations.of(context)!.question7),
    FAqsModel(
        ans: AppLocalizations.of(context)!.answer8,
        count: "8",
        color: Colors.cyanAccent.shade100,
        question: AppLocalizations.of(context)!.question8),
    FAqsModel(
        ans: AppLocalizations.of(context)!.answer9,
        count: "9",
        color: Colors.grey.shade100,
        question: AppLocalizations.of(context)!.question9),
    FAqsModel(
        ans: AppLocalizations.of(context)!.answer10,
        count: "10",
        color: Colors.pink.shade100,
        question: AppLocalizations.of(context)!.question10),
  ];
}

class FAqsModel {
  final String ans;
  final String count;
  final Color color;
  final String question;
  FAqsModel({
    required this.ans,
    required this.count,
    required this.color,
    required this.question,
  });
}
