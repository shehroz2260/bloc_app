import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:chat_with_bloc/widgets/see_more_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../account_creation_view/preference_view.dart';

class UserProfileView extends StatelessWidget {
  final UserModel user;
  const UserProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
       body: Stack(
         children: [
           SingleChildScrollView(
             child: Column(
              children: [
                SizedBox(
                  height: 350,
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            AppCacheImage(
                              imageUrl: user.profileImage,
                              width: double.infinity,
                              height: 350,
                              round: 0,
                            ),
                            
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                   height: 30,
                                   width: double.infinity,
                                  decoration:  BoxDecoration(
                                   color: AppColors.whiteColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)
                                    )
                                  ),
                                  ),
                                )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 40),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                   const AppHeight(height: 60),
                   Row(
                     children: [
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               children: [
                                 Text("${user.firstName}, ",style: AppTextStyle.font25.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold)),
                                  Text(user.age.toString(),style: AppTextStyle.font25.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold)),
                                 
                               ],
                             ),
                              Text(" ${user.bio}")
                           ],
                         ),
                       ),
                       Container(
                         height: 60,
                         width: 60,
                         decoration: BoxDecoration(
                           border: Border.all(
                             color: AppColors.borderGreyColor
                           ),
                           borderRadius: BorderRadius.circular(20)
                         ),
                         padding: const EdgeInsets.all(12),
                         child: SvgPicture.asset(AppAssets.sendIcon),                  
                       )
                     ],
                   ),
                   const AppHeight(height: 30),
                   Row(
                     children: [
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("Location",style: AppTextStyle.font20.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold),),
                             Text("user.location",style: AppTextStyle.font16.copyWith(color: AppColors.blackColor),)
                           ],
                         ),
                       ),
                       Container(
                         decoration: BoxDecoration(
                           color: AppColors.redColor.withOpacity(0.15),
                           borderRadius: BorderRadius.circular(7),
                         ),
                         padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                         child: Row(
                           children: [
                             SvgPicture.asset(AppAssets.locationICon),
                             const AppWidth(width: 10),
                              Text("1 km",style: AppTextStyle.font16.copyWith(color: AppColors.redColor,fontWeight: FontWeight.w600),)
                           ],
                         ),
                       )
                     ],
                   ),
                   const AppHeight(height: 30),
                     Text("About",style: AppTextStyle.font20.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold),),
                      TextWithSeeMore(text: user.about),
                     const AppHeight(height: 30),
                     Text("Interests",style: AppTextStyle.font20.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold),),
                   const AppHeight(height: 10),
                   GridView.builder(
                     shrinkWrap: true,
                     hitTestBehavior: HitTestBehavior.opaque,
                     padding: EdgeInsets.zero,
                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 10,childAspectRatio: 3.3),itemCount: user.myInstrest.length, itemBuilder: (context,index){
                     final interest = user.myInstrest[index];
                     return Container(
                           padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                           decoration: BoxDecoration(
                             color:  AppColors.redColor,
                             borderRadius: BorderRadius.circular(15),
                             border:  Border.all(color: AppColors.redColor)
                           ),
                           child: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                              SvgPicture.asset(interestList[interest].icon,colorFilter: ColorFilter.mode( AppColors.whiteColor,BlendMode.srcIn)),
                              const AppWidth(width: 10),
                              Text(interestList[interest].name,style: AppTextStyle.font16.copyWith(color: AppColors.whiteColor))
                             ],
                           ),
                                             );
                   }),
                   const AppHeight(height: 30),
                   GestureDetector(
                     onTap: () {
                       
                     },
                     behavior: HitTestBehavior.opaque,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Gallery",style: AppTextStyle.font20.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold)),
                         Text("See all",style: AppTextStyle.font16.copyWith(color: AppColors.redColor,fontWeight: FontWeight.bold))
                       ]
                       ),
                   ),
                   const AppHeight(height: 10),
                   
                     ],
                   ),
                 )
              ],
             ),
           ),
            const Positioned(
                              top: 70,
                              left: 30,
                              child: CustomBackButton(isUSerPRofile: true)),
         ],
       ),
    );
  }
}