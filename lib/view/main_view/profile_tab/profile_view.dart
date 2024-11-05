// // ignore_for_file: use_build_context_synchronously
import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/edit_profile.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/galler_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/setting_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          Material(
            elevation: 4,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
            ),
            child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
              ),
              color: AppColors.borderGreyColor,
            
            ),
            height: MediaQuery.of(context).size.height * 0.63,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: BlocBuilder<UserBaseBloc, UserBaseState>(
              builder: (context,state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.redColor
                    ),
                    padding: const EdgeInsets.all(4),
                    child: AppCacheImage(imageUrl: state.userData.profileImage,height: 180,width: 180,round: 180)),
                  const AppHeight(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${state.userData.firstName}, ",style: AppTextStyle.font25.copyWith(color: AppColors.blackColor)),
                      Text(state.userData.age.toString(),style: AppTextStyle.font30.copyWith(color: AppColors.blackColor)),
                    ],
                  ),
                  const AppHeight(height: 25),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Padding(
                       padding: const EdgeInsets.only(bottom: 40),
                       child: ProfileWidget(
                        title: "Settings",
                        icon: AppAssets.settingICon,
                        onTap: () {
                          Go.to(context, const SettingView());
                        },
                       ),
                     ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: ProfileWidget(
                        title: "Edit profile",
                        icon: AppAssets.pencilICon,
                        onTap: () {
                          Go.to(context, const EditProfile());
                        }, ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: ProfileWidget(
                        title: "Gallery",
                        icon: '',
                        onTap: () {
                          Go.to(context, const GallerView());
                        },
                                         ),
                      ),
                   
                    ],
                  ),
                  const AppHeight(height: 30)
                  ],
                );
              }
            ),
            ),
          ),
          
        //  const Spacer(),
        //    const Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 40),
        //     child: CustomNewButton(btnName: "Delete Account"),
        //   ),
        //   const AppHeight(height: 20),
        //    Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 40),
        //     child: CustomNewButton(
        //       isFillColor: false,
        //       btnColor: AppColors.redColor.withOpacity(0.3),
        //       btnName: "Logout",onTap: ()async {
             
        //     },),
        //   ),
          const AppHeight(height: 30)
        ],
      );
  }
}

class ProfileWidget extends StatelessWidget {
  final void Function() onTap;
  final String icon;
  final String title;
  const ProfileWidget({
    super.key, required this.onTap,
     required this.icon,
     required this.title
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
           decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:  AppColors.redColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 4,spreadRadius: 4
              )
            ],
           ),
           padding: const EdgeInsets.all(20),
           child:icon.isEmpty? Icon(Icons.camera_alt,color: AppColors.whiteColor,size: 32): SvgPicture.asset(icon,colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),),
          ),
          const AppHeight(height: 7),
           Text(title,style: AppTextStyle.font16.copyWith(color: AppColors.blackColor))
        ],
      ),
    );
  }
}



class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}