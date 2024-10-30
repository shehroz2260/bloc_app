import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../model/user_model.dart';

class CongratsMessageView extends StatelessWidget {
  final UserModel user;
  const CongratsMessageView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          const AppHeight(height: 30),
          Image.asset("assets/images/png/match_message_image.png"),
          Text("It’s a match, ${user.firstName}!",
              style: AppTextStyle.font30.copyWith(color: AppColors.redColor)),
          Text("Start a conversation now with each other",
              style: AppTextStyle.font16.copyWith(color: AppColors.blackColor)),
          const AppHeight(height: 20),
          // BlocBuilder<InboxBloc, InboxState>(
          //   builder: (context, state) {
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 40),
          //       child: CustomNewButton(
          //         btnName: "Say, hello",
          //         onTap: () {
          //         final model =  state.threadList.where((e)=> e.participantUserList.contains(user.uid)).toList().first;
          //         Go.to(context, ChatScreen(model: model,isFromCongrats: true));
          //         },
          //       ),
          //     );
          //   },
          // ),
          const AppHeight(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: CustomNewButton(
              onTap: () => Go.back(context),
              btnName: "Keep swiping",
              btnColor: AppColors.redColor.withOpacity(0.2),
              isFillColor: false,
            ),
          ),
        ],
      ),
    );
  }
}
