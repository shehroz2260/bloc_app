import 'package:chat_with_bloc/widgets/show_case_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';
import '../src/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar(
      {super.key,
      required this.ontap,
      required this.currentIndex,
      required this.key7,
      required this.key8,
      required this.key10,
      required this.key9});
  final void Function(int) ontap;
  final int currentIndex;
  final GlobalKey key7;
  final GlobalKey key8;
  final GlobalKey key9;
  final GlobalKey key10;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: 80,
      width: mediaQuery.width,
      color: AppColors.offWhiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(iconLists.length, (index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ontap(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Showcaseview(
                  description: diss(context)[index],
                  title: title[index],
                  targetBorderRadius: BorderRadius.circular(50),
                  tooltipPosition: TooltipPosition.top,
                  globalKey: index == 1
                      ? key7
                      : index == 2
                          ? key8
                          : index == 3
                              ? key9
                              : index == 4
                                  ? key10
                                  : GlobalKey(),
                  child: SvgPicture.asset(
                      index == currentIndex
                          ? iconLists[index]
                          : unSelectedIconLists[index],
                      colorFilter: index == 4 && currentIndex == 4
                          ? ColorFilter.mode(
                              AppColors.redColor, BlendMode.srcIn)
                          : null,
                      height: 30,
                      width: 30),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

List<String> iconLists = [
  "assets/images/svg/cards.svg",
  "assets/images/svg/selectedIndicator.svg",
  "assets/images/svg/selectedMessage.svg",
  "assets/images/svg/selected_posts.svg",
  "assets/images/svg/people.svg"
];
List<String> diss(BuildContext context) {
  return [
    "",
    AppLocalizations.of(context)!.navInst1,
    AppLocalizations.of(context)!.navInst2,
    AppLocalizations.of(context)!.navInst3,
    AppLocalizations.of(context)!.navInst4
  ];
}

List<String> title = ["", "Likes", "Chat", "Posts", "Profile"];
List<String> unSelectedIconLists = [
  "assets/images/svg/unSelectedCard.svg",
  "assets/images/svg/indicator.svg",
  "assets/images/svg/message.svg",
  "assets/images/svg/posts.svg",
  "assets/images/svg/people.svg"
];

class CustomAdminNavigationBar extends StatelessWidget {
  const CustomAdminNavigationBar({
    super.key,
    required this.ontap,
    required this.currentIndex,
  });
  final void Function(int) ontap;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: 80,
      width: mediaQuery.width,
      color: AppColors.offWhiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(iconLists.length, (index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ontap(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  adminIcon[index],
                  color: index == currentIndex
                      ? AppColors.redColor
                      : Colors.black.withAlpha((0.7 * 255).toInt()),
                  size: 30,
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

List<IconData> adminIcon = [
  Icons.people_sharp,
  Icons.pie_chart,
  Icons.message,
  Icons.person_2_rounded
];
