// // ignore_for_file: use_build_context_synchronously
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/splash_view/splash_view.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_bloc.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_event.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final user = context.read<UserBaseBloc>().state.userData;
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          Material(
            elevation: 10,
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
              color: AppColors.redColor.withOpacity(0.5),
            
            ),
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.redColor
                ),
                padding: const EdgeInsets.all(4),
                child: AppCacheImage(imageUrl: user.profileImage,height: 180,width: 180,round: 180)),
              const AppHeight(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${user.firstName}, ",style: AppTextStyle.font25),
                  Text(user.age.toString(),style: AppTextStyle.font30),
                ],
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Padding(
                   padding: const EdgeInsets.only(bottom: 40),
                   child: ProfileWidget(
                    title: "Settings",
                    icon: AppAssets.settingICon,
                    onTap: () {
                      
                    },
                   ),
                 ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: ProfileWidget(
                    title: "Edit profile",
                    icon: AppAssets.pencilICon,
                    onTap: () {
                      
                    }, ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: ProfileWidget(
                    title: "Gallery",
                    icon: '',
                    onTap: () {
                      
                    },
                                     ),
                  ),
               
                ],
              ),
              const AppHeight(height: 30)
              ],
            ),
            ),
          ),
          
         const Spacer(),
           const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: CustomNewButton(btnName: "Delete Account",isFillColor: false),
          ),
          const AppHeight(height: 20),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: CustomNewButton(btnName: "Logout",onTap: ()async {
               var result = await showOkCancelAlertDialog(context: context,message: "Do you really want to logout",title: "Are you really",okLabel: "Yes",cancelLabel: "Not now");
              if(result == OkCancelResult.cancel) return;
              await FirebaseAuth.instance.signOut();
              context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: UserModel.emptyModel));
              context.read<MainBloc>().add(ChangeIndexEvent(index: 0));
              Go.offAll(context, const SplashView());
            },),
          ),
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
      onTap: () {
        
      },
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
           decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: icon.isEmpty? AppColors.redColor: AppColors.whiteColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 4,spreadRadius: 4
              )
            ],
           ),
           padding: const EdgeInsets.all(20),
           child:icon.isEmpty? Icon(Icons.camera_alt,color: AppColors.whiteColor,size: 32): SvgPicture.asset(icon,colorFilter: ColorFilter.mode(AppColors.redColor, BlendMode.srcIn),),
          ),
          const AppHeight(height: 7),
           Text(title,style: AppTextStyle.font16)
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