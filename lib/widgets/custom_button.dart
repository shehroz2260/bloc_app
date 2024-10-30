import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../src/app_assets.dart';
import '../src/app_colors.dart';
import '../src/app_text_style.dart';
import '../src/go_file.dart';

class CustomButton extends StatelessWidget {
  final String btnName;
  final Color? color;
  final Color? textColor;
  final void Function()? onTap;
  const CustomButton({
    super.key, required this.btnName,  this.onTap,this.color,this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:color ?? AppColors.blueColor,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: Text(btnName,style: AppTextStyle.font16.copyWith(color: textColor?? AppColors.whiteColor)),
      ),
    );
  }
}



class CustomSigninBtnWithSocial extends StatelessWidget {
  final void Function()? onTap;
  final bool isApple;
  final String? icon;
  const CustomSigninBtnWithSocial({
    super.key,
    this.onTap,
    this.icon,
    this.isApple = false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(15),
         border: Border.all(color: AppColors.borderGreyColor)
       ),
       padding: const EdgeInsets.all(15),
       child:  SvgPicture.asset(icon?? (isApple? AppAssets.appleIcon: AppAssets.googleIcon),height: 30,width: 30),
      ),
    );
  }
}


class CustomNewButton extends StatelessWidget {
  final String btnName;
  final void Function()? onTap;
  final bool isFillColor;
  final Color? btnColor;
  final bool isRow;
  const CustomNewButton({
    super.key, required this.btnName, this.onTap,this.isFillColor = true, this.btnColor, this.isRow = false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: onTap,
      child: Container(
       width: double.infinity,
       decoration: BoxDecoration(
         color: btnColor?? (isFillColor? AppColors.redColor: null),
         borderRadius: BorderRadius.circular(15),
         border: Border.all(
          color: AppColors.borderGreyColor,
         )
       ),
       padding:  const EdgeInsets.symmetric(vertical: 16),
       alignment: Alignment.center,
       child:isRow? Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20),
         child: Row(
          children: [
            SvgPicture.asset(AppAssets.calenderIcon),
            const AppWidth(width: 15),
            Text(btnName,style: AppTextStyle.font16.copyWith(fontWeight: FontWeight.bold,color:   AppColors.redColor))
          ],
         ),
       ):  Text(btnName,style: AppTextStyle.font16.copyWith(fontWeight: FontWeight.bold,color: isFillColor? AppColors.whiteColor: AppColors.redColor)),
      ),
    );
  }
}



class CustomBackButton extends StatelessWidget {
  final bool isUSerPRofile;
  const CustomBackButton({
    super.key,
    this.isUSerPRofile = false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Go.back(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUSerPRofile? AppColors.whiteColor.withOpacity(0.5): null,
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Icon(Icons.arrow_back_ios_outlined,color: AppColors.redColor)),
    );
  }
}