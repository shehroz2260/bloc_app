import 'package:flutter/material.dart';
import '../src/app_colors.dart';
import '../src/app_text_style.dart';

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
      height: 100,
      width: mediaQuery.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.whiteColor)
        ),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
        color: AppColors.blackColor.withOpacity(0.6)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(iconList.length, (index){
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: ()=> ontap(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconList[index],size: 25,color: index == currentIndex?AppColors.whiteColor:AppColors.whiteColor.withOpacity(0.7))
              ,Text(labelList[index],style: AppTextStyle.font16.copyWith(fontSize: 14,color: index == currentIndex?AppColors.whiteColor:AppColors.whiteColor.withOpacity(0.7)))
              ],
            ),
          );
        }),
      ),
    );
  }
}

List<IconData> iconList = [
  Icons.home,
  Icons.map,
  Icons.message,
  Icons.person,
];
List<String> labelList = [
  "Home",
  "Map",
  "Chat",
  "Profile",
];