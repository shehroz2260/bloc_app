import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/about_us_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/edit_profile.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/user_model.dart';
import '../../../src/go_file.dart';
import '../../../view_model/main_bloc/main_bloc.dart';
import '../../../view_model/main_bloc/main_event.dart';
import '../../../view_model/user_base_bloc/user_base_bloc.dart';
import '../../../view_model/user_base_bloc/user_base_event.dart';
import '../../../widgets/custom_button.dart';
import '../../splash_view/splash_view.dart';
import 'change_password_view.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  String get signinMethod {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    for (UserInfo userInfo in user.providerData) {
      switch (userInfo.providerId) {
        case 'password':
          return 'password';
        case 'google.com':
          return 'google';
        case 'apple.com':
          return 'apple';
        case 'phone':
          return 'phone number';
        default:
          return 'Signed in with ${userInfo.providerId}';
      }
    }
  }
  return "not signed in";
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              const AppHeight(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           const CustomBackButton(),
                             Text(
                              'Settings',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                  color: AppColors.blackColor,
                                  fontSize: 30),
                            ),
                            const SizedBox(width: 60),

                          ],
                        ),
                        const AppHeight(height: 20),
                        BlocBuilder<UserBaseBloc, UserBaseState>(
                          builder: (context,userState) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.borderColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  AppCacheImage(imageUrl: userState.userData.profileImage,height: 60,width: 60,round: 60),
                                  const AppWidth(width: 12),
                                   Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Text(userState.userData.firstName,style: AppTextStyle.font20.copyWith(
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w700
                                    ),),
                                     GestureDetector(
                                      onTap: () {
                                        Go.to(context, const EditProfile());
                                      },
                                       child: Text("Edit Profile",style: AppTextStyle.font16.copyWith(
                                        color: AppColors.blueColor,
                                       
                                       )),
                                     ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                        ),
                        const AppHeight(height: 20),
                          SettiingWidget(
                          color: Colors.amber,
                          icon: Icons.info,
                          onTap: () {
                            Go.to(context, const AboutUsView());
                          },
                          title: "About us",
                         ),
                        if(signinMethod == "password")
                         SettiingWidget(
                          color: Colors.blue,
                          icon: Icons.lock_open_outlined,
                          onTap: () {
                            Go.to(context, const ChangePasswordView());
                          },
                          title: "Change password",
                         ),
                          
                         SettiingWidget(
                          color: Colors.green,
                          icon: Icons.message,
                          onTap: () {},
                          title: "Contact us",
                         ),
                         SettiingWidget(
                          color: Colors.purple,
                          icon: Icons.policy,
                          onTap: () {},
                          title: "Terms & Conditions",
                         ),
                         SettiingWidget(
                          color: Colors.orange,
                          icon: Icons.help_outline,
                          onTap: () {},
                          title: "FAQs",
                         ),
                         SettiingWidget(
                          color: Colors.red,
                          icon: Icons.delete_forever,
                          onTap: () {},
                          title: "Delete Account",
                         ),
                         SettiingWidget(
                          color: Colors.pinkAccent.shade100,
                          icon: Icons.logout_outlined,
                          onTap: () async{
                              var result = await showOkCancelAlertDialog(context: context,message: "Do you really want to logout",title: "Are you really",okLabel: "Yes",cancelLabel: "Not now");
                               if(result == OkCancelResult.cancel) return;
                               await FirebaseAuth.instance.signOut();
                               context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: UserModel.emptyModel));
                               context.read<MainBloc>().add(ChangeIndexEvent(index: 0));
                               Go.offAll(context, const SplashView());
                          },
                          title: "Logout",
                         ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettiingWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onTap;
  final Color color;
  const SettiingWidget({
    super.key, required this.icon, required this.title, required this.onTap, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Container(
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: color
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon,color: AppColors.whiteColor),
            ),
            const AppWidth(width: 12),
            Expanded(child: Text(title,style: AppTextStyle.font20.copyWith(color: AppColors.blackColor))),
           const Icon(Icons.arrow_forward_ios_outlined)
          ],
        ),
      ),
    );
  }
}