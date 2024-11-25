import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../src/app_text_style.dart';
import '../../../widgets/custom_button.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

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
                Text(AppLocalizations.of(context)!.aboutUs,
                    style:
                        AppTextStyle.font25.copyWith(color: theme.textColor)),
                const SizedBox(width: 50),
              ],
            ),
            const AppHeight(height: 20),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Welcome to Friendzy – the place where meaningful connections begin! Our mission is simple: to help people find genuine relationships in a safe, inclusive, and supportive environment. We believe in fostering connections that go beyond superficial swipes and endless scrolling. Our app is designed to bring people together who share common interests, values, and goals.",
                      style:
                          AppTextStyle.font16.copyWith(color: theme.textColor)),
                  const AppHeight(height: 12),
                  Text(
                    "Why Choose Us?",
                    style: AppTextStyle.font20.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600),
                  ),
                  const AppHeight(height: 10),
                  AboutUsWidget(
                    color: Colors.green.shade100,
                    title: "Authentic Connections",
                    desc:
                        "We prioritize real, verified profiles, so you can be sure you’re meeting genuine people looking for the same thing you are.",
                  ),
                  AboutUsWidget(
                      color: Colors.pink.shade100,
                      title: "Safety First",
                      desc:
                          " Your privacy and security are our top priorities. With in-app verification and a dedicated team monitoring for suspicious activity, we strive to create a safe space for everyone."),
                  AboutUsWidget(
                    color: Colors.amber.shade100,
                    desc:
                        "Our algorithm takes into account more than just appearances. By focusing on personality, interests, and compatibility, we help you find matches who really resonate with you.",
                    title: "Smart Matching",
                  ),
                  AboutUsWidget(
                      color: Colors.purple.shade100,
                      title: "Diverse Community",
                      desc:
                          "Whether you’re looking for friendship, a casual date, or a long-term partner, you’ll find a diverse community of people looking for the same."),
                  const AppHeight(height: 5),
                  Text(
                      "At Friendzy, we understand that dating can be daunting, but it doesn’t have to be. We’re here to make it a fun, exciting, and rewarding experience. Join us today and discover connections that matter.",
                      style: AppTextStyle.font16
                          .copyWith(color: AppColors.blackColor)),
                ],
              ),
            ))
          ],
        )),
      ),
    );
  }
}

class AboutUsWidget extends StatelessWidget {
  final String title;
  final String desc;
  final Color color;
  const AboutUsWidget(
      {super.key,
      required this.title,
      required this.desc,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 5,
            width: 5,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppColors.blackColor),
          ),
          const AppWidth(width: 10),
          Expanded(
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "$title: ",
                  style: AppTextStyle.font16.copyWith(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w700)),
              TextSpan(
                  text: desc,
                  style: AppTextStyle.font16
                      .copyWith(color: AppColors.blackColor)),
            ])),
          )
        ],
      ),
    );
  }
}
