import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../src/app_colors.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    super.key,
    required this.ontap, 
    required this.currentIndex
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
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(iconLists.length, (index){
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: ()=> ontap(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(index == currentIndex?  iconLists[index]: unSelectedIconLists[index],colorFilter:index ==3 && currentIndex ==3? ColorFilter.mode( AppColors.redColor, BlendMode.srcIn): null,height: 30,width: 30),
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
List<String> unSelectedIconLists = [
  "assets/images/svg/unSelectedCard.svg",
  "assets/images/svg/indicator.svg",
  "assets/images/svg/message.svg",
  "assets/images/svg/people.svg"
];