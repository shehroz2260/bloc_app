import 'package:flutter/material.dart';
import '../src/app_assets.dart';
import '../src/app_colors.dart';
import '../src/app_string.dart';
import '../src/app_text_style.dart';
import '../src/width_hieght.dart';

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
  const CustomSigninBtnWithSocial({
    super.key,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20),
         border: Border.all(color: AppColors.whiteColor)
       ),
       padding: const EdgeInsets.symmetric(
         vertical: 12,
         horizontal: 10
       ),
       child:  Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Image.asset(AppAssets.googleIcon,height: 30,width: 30),
           Text(AppStrings.signInWithGoogle,style: AppTextStyle.font16),
           const AppWidth(width: 30)
         ],
       ),
      ),
    );
  }
}
