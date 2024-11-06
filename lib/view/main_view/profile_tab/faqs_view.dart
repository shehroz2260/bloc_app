// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';

import '../../../src/app_text_style.dart';
import '../../../widgets/custom_button.dart';

class FaqsView extends StatelessWidget {
  const FaqsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
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
                Text("FAQs",
                    style: AppTextStyle.font25
                        .copyWith(color: AppColors.blackColor)),
                const SizedBox(width: 50),
              ],
            ),
            const AppHeight(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(_faqsList.length, (index) {
                    return FAQWidget(
                        color: _faqsList[index].color,
                        count: _faqsList[index].count,
                        title: _faqsList[index].question,
                        desc: _faqsList[index].ans);
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

List<FAqsModel> _faqsList = [
  FAqsModel(
      ans:
          "To create an account, simply download the Friendzy from the App Store or Google Play, open the app, and follow the registration prompts. You can sign up using your email address, phone number, or social media accounts.",
      count: "1",
      color: Colors.amber.shade100,
      question: "How do I create an account?"),
  FAqsModel(
      ans:
          "Yes! At Friendzy, we prioritize your privacy and security. We use advanced encryption and privacy controls to protect your information. We never share your data with third parties without your consent.",
      count: "2",
      color: Colors.blue.shade100,
      question: "Is my personal information safe?"),
  FAqsModel(
      ans:
          "Our matching algorithm takes into account your interests, preferences, and location to suggest potential matches. The more you interact with the app, the better your matches will become!",
      count: "3",
      color: Colors.green.shade100,
      question: "How does the matching process work?"),
  FAqsModel(
      ans:
          "Absolutely! If you encounter someone who makes you uncomfortable, you can easily block or report them through their profile. We take user safety seriously and investigate any reports thoroughly.",
      count: "4",
      color: Colors.purple.shade100,
      question: "Can I block or report someone?"),
  FAqsModel(
      ans:
          "Friendzy is free to use, but we offer premium features through in-app purchases. These features may include unlimited messaging, seeing who liked your profile, and more.",
      count: "5",
      color: Colors.orange.shade100,
      question: "Are there in-app purchases?"),
  FAqsModel(
      ans:
          "If you wish to delete your account, go to the app profile tab, select Setting,” and choose the option to delete your account. Please note that this action is permanent and cannot be undone.",
      count: "6",
      color: Colors.red.shade100,
      question: "How can I delete my account?"),
  FAqsModel(
      ans:
          "Yes! Friendzy is designed to cater to a wide range of relationship preferences, from casual dating to serious commitments. You can specify your intentions in your profile.",
      count: "7",
      color: Colors.green.shade100,
      question:
          "Can I use the app if I’m not looking for a serious relationship?"),
  FAqsModel(
      ans:
          "To reset your password, go to the login screen, select “Forgot Password?”, and follow the instructions sent to your registered email or phone number.",
      count: "8",
      color: Colors.cyanAccent.shade100,
      question: "How do I reset my password?"),
  FAqsModel(
      ans:
          "If you experience any technical difficulties, please contact our support team through the app or our website. We’re here to help you!",
      count: "9",
      color: Colors.grey.shade100,
      question: "What should I do if I’m having technical issues?"),
  FAqsModel(
      ans:
          "Yes! Friendzy is available in multiple countries. You can connect with people in different locations and adjust your search preferences accordingly.",
      count: "10",
      color: Colors.pink.shade100,
      question: "Can I use the app in multiple countries?"),
];

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
