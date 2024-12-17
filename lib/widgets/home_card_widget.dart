import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import '../model/user_model.dart';
import '../src/app_text_style.dart';
import '../src/go_file.dart';
import '../view/main_view/match_tab/user_profile_view/user_profile_view.dart';
import '../view_model/home_bloc/home_bloc.dart';
import '../view_model/home_bloc/home_event.dart';
import 'app_cache_image.dart';
import 'home_widgets.dart';
import 'show_case_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.user,
  });

  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              AppCacheImage(
                onTap: () {
                  Go.to(context, UserProfileView(user: user));
                },
                imageUrl: user.profileImage,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.75,
                round: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "${user.firstName} ${user.lastName}, ",
                          style: AppTextStyle.font25),
                      TextSpan(text: "${user.age}", style: AppTextStyle.font30)
                    ])),
                    Text(user.bio, style: AppTextStyle.font20)
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  context.read<HomeBloc>().add(DisLikeUser(
                      likee: user,
                      liker: context.read<UserBaseBloc>().state.userData,
                      context: context));
                },
                child: const LikeAndDisLikeWidget(
                  icon: "assets/images/svg/Vector (1).svg",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: GestureDetector(
                  onTap: () {
                    context.read<HomeBloc>().add(LikeUser(
                        likee: user,
                        context: context,
                        liker: context.read<UserBaseBloc>().state.userData));
                  },
                  child: const LikeAndDisLikeWidget(
                      isLike: true,
                      icon: "assets/images/svg/Vector.svg",
                      height: 70),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context
                      .read<HomeBloc>()
                      .add(OnReportUser(context: context, userModel: user));
                },
                child: const LikeAndDisLikeWidget(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class HomeCardForMessage extends StatelessWidget {
  const HomeCardForMessage({
    super.key,
    required this.key3,
    required this.key4,
    required this.key5,
    required this.key6,
    required this.key7,
  });
  final GlobalKey key3;
  final GlobalKey key4;
  final GlobalKey key5;
  final GlobalKey key6;
  final GlobalKey key7;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              AppCacheImage(
                onTap: () {},
                imageUrl:
                    context.read<UserBaseBloc>().state.userData.profileImage,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.75,
                round: 25,
              ),
              Align(
                alignment: Alignment.center,
                child: Showcaseview(
                  globalKey: key7,
                  description:
                      AppLocalizations.of(context)!.swipeUpAndDownToExplore,
                  title: AppLocalizations.of(context)!.findMatch,
                  tooltipPosition: TooltipPosition.bottom,
                  targetBorderRadius: BorderRadius.circular(40),
                  child: const SizedBox(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Showcaseview(
                  globalKey: key3,
                  description: AppLocalizations.of(context)!.clickToSeeUserInfo,
                  title: AppLocalizations.of(context)!.info,
                  tooltipPosition: TooltipPosition.bottom,
                  targetBorderRadius: BorderRadius.circular(40),
                  child: const SizedBox(),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Showcaseview(
                targetBorderRadius: BorderRadius.circular(50),
                description:
                    AppLocalizations.of(context)!.clickIfYouDontWantToMatch,
                globalKey: key5,
                tooltipPosition: TooltipPosition.top,
                title: AppLocalizations.of(context)!.notYourMatch,
                child: const LikeAndDisLikeWidget(
                    icon: "assets/images/svg/Vector (1).svg"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Showcaseview(
                  targetBorderRadius: BorderRadius.circular(70),
                  description: AppLocalizations.of(context)!.clickToLikeUser,
                  globalKey: key4,
                  tooltipPosition: TooltipPosition.top,
                  title: AppLocalizations.of(context)!.like,
                  child: const LikeAndDisLikeWidget(
                      icon: "assets/images/svg/Vector.svg",
                      height: 70,
                      isLike: true),
                ),
              ),
              Showcaseview(
                targetBorderRadius: BorderRadius.circular(40),
                description:
                    AppLocalizations.of(context)!.clickIfYouWantToReportUser,
                globalKey: key6,
                tooltipPosition: TooltipPosition.top,
                title: AppLocalizations.of(context)!.report,
                child: const LikeAndDisLikeWidget(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
