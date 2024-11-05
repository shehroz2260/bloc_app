import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
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

class SettingView extends StatelessWidget {
  const SettingView({super.key});

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
                          children: [
                           const CustomBackButton(),
                            const SizedBox(width: 20),
                             Text(
                              'Settings',
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 38),
                            ),
                          ],
                        ),
                        const AppHeight(height: 30),
                         SettiingWidget(
                          color: Colors.blue,
                          icon: Icons.lock_open_outlined,
                          onTap: () {},
                          title: "Change password",
                         ),
                          SettiingWidget(
                          color: Colors.orange,
                          icon: Icons.help_outline,
                          onTap: () {},
                          title: "Faqs",
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