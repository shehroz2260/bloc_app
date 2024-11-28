import 'package:chat_with_bloc/widgets/show_case_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';
import '../src/app_colors.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar(
      {super.key,
      required this.ontap,
      required this.currentIndex,
      required this.key7,
      required this.key8,
      required this.key9});
  final void Function(int) ontap;
  final int currentIndex;
  final GlobalKey key7;
  final GlobalKey key8;
  final GlobalKey key9;
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
                  description: diss[index],
                  title: title[index],
                  targetBorderRadius: BorderRadius.circular(50),
                  tooltipPosition: TooltipPosition.top,
                  globalKey: index == 1
                      ? key7
                      : index == 2
                          ? key8
                          : index == 3
                              ? key9
                              : GlobalKey(),
                  child: SvgPicture.asset(
                      index == currentIndex
                          ? iconLists[index]
                          : unSelectedIconLists[index],
                      colorFilter: index == 3 && currentIndex == 3
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
  "assets/images/svg/people.svg"
];
List<String> diss = [
  "",
  "Click this tab to see yours likes",
  "Click this tab to chat with your matches",
  "Click this tab to see your profile"
];
List<String> title = ["", "Likes", "Chat", "Profile"];
List<String> unSelectedIconLists = [
  "assets/images/svg/unSelectedCard.svg",
  "assets/images/svg/indicator.svg",
  "assets/images/svg/message.svg",
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
                // SvgPicture.asset(
                //     index == currentIndex
                //         ? iconLists[index]
                //         : unSelectedIconLists[index],
                //     colorFilter: index == 3 && currentIndex == 3
                //         ? ColorFilter.mode(AppColors.redColor, BlendMode.srcIn)
                //         : null,
                //     height: 30,
                //     width: 30),
                Icon(adminIcon[index],
                    color: index == currentIndex ? AppColors.redColor : null)
              ],
            ),
          );
        }),
      ),
    );
  }
}

List<IconData> adminIcon = [
  Icons.home_filled,
  Icons.people,
  Icons.message,
  Icons.person_2_rounded
];
