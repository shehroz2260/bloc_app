// // ignore_for_file: use_build_context_synchronously
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/edit_profile.dart';
import 'package:chat_with_bloc/view/splash_view/splash_view.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_bloc.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_event.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserBaseBloc>().state.userData;
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          children: [
            const AppHeight(height: 50),
            Text(AppStrings.profile,style: AppTextStyle.font25),
            const AppHeight(height: 15),
            AppCacheImage(imageUrl: user.profileImage,height: 110,width: 110,round: 110),
            const AppHeight(height: 10),
            Text(user.firstName,style: AppTextStyle.font16),
            Text(user.email,style: AppTextStyle.font16),
            const AppHeight(height: 30),
            GestureDetector(
              onTap: () async{
            Go.to(context, const EditProfile());
              },
              behavior: HitTestBehavior.opaque,
               child: Row(
                children: [
                  Icon(Icons.person_2,color: AppColors.blueColor,size: 30),
                  const AppWidth(width: 10),
                   Text(AppStrings.profile,style: AppTextStyle.font16)
                ],
                           ),
             ),
            const AppHeight(height: 20),
             GestureDetector(
              onTap: () async{
                var result = await showOkCancelAlertDialog(context: context,message: "Do you really want to logout",title: "Are you really",okLabel: "Yes",cancelLabel: "Not now");
                if(result == OkCancelResult.cancel) return;
                await FirebaseAuth.instance.signOut();
                context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: UserModel.emptyModel));
                context.read<MainBloc>().add(ChangeIndexEvent(index: 0));
                Go.offAll(context, const SplashView());
              },
              behavior: HitTestBehavior.opaque,
               child: Row(
                children: [
                  Icon(Icons.logout,color: AppColors.blueColor,size: 30),
                  const AppWidth(width: 10),
                   Text(AppStrings.logout,style: AppTextStyle.font16)
                ],
                           ),
             )
          ],
        ),
    );
  }
}