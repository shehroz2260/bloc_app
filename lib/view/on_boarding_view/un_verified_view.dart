import 'dart:async';

import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/main_view/main_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/contact_us_view.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../model/user_model.dart';
import '../../view_model/user_base_bloc/user_base_bloc.dart';
import '../../view_model/user_base_bloc/user_base_event.dart';

class UnVerifiedView extends StatefulWidget {
  const UnVerifiedView({super.key});

  @override
  State<UnVerifiedView> createState() => _UnVerifiedViewState();
}

class _UnVerifiedViewState extends State<UnVerifiedView> {
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> sub;

  @override
  void initState() {
    onInit();
    super.initState();
  }

  void onInit() {
    sub = FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
        .snapshots()
        .listen((e) async {
      var user = UserModel.fromMap(e.data() ?? {});
      if (user.isVerified) {
        Go.offAll(context, const MainView());
      }
      context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const AppHeight(height: 60),
            Text(
              "Blocked",
              style: AppTextStyle.font25.copyWith(color: theme.textColor),
            ),
            const AppHeight(height: 120),
            SvgPicture.asset(AppAssets.appIcon),
            const AppHeight(height: 50),
            Text(
              "You are blocked by Admin, If you have any query please contact us",
              style: AppTextStyle.font20.copyWith(color: theme.textColor),
              textAlign: TextAlign.center,
            ),
            const AppHeight(height: 50),
            const AppHeight(height: 30),
            CustomNewButton(
              btnName: "Contact us",
              onTap: () {
                Go.to(context, const ContactUsView());
              },
            )
          ],
        ),
      ),
    );
  }
}
