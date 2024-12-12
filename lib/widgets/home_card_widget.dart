import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import '../model/user_model.dart';
import '../src/app_colors.dart';
import '../src/app_text_style.dart';
import '../src/go_file.dart';
import '../view/main_view/match_tab/user_profile_view/user_profile_view.dart';
import '../view_model/home_bloc/home_bloc.dart';
import '../view_model/home_bloc/home_event.dart';
import 'app_cache_image.dart';
import 'show_case_widget.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.user,
  });

  final UserModel user;
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              AppCacheImage(
                onTap: () {},
                imageUrl: user.profileImage,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.75,
                round: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    WidgetForLikeorDislike(
                        icon: Icons.info,
                        onTap: () {
                          Go.to(context, UserProfileView(user: user));
                        }),
                    const SizedBox(height: 15),
                    WidgetForLikeorDislike(
                        icon: Icons.favorite,
                        onTap: () {
                          context.read<HomeBloc>().add(LikeUser(
                              likee: user,
                              context: context,
                              liker:
                                  context.read<UserBaseBloc>().state.userData));
                        }),
                    const SizedBox(height: 15),
                    WidgetForLikeorDislike(
                        icon: Icons.remove,
                        onTap: () {
                          context.read<HomeBloc>().add(DisLikeUser(
                              likee: user,
                              liker:
                                  context.read<UserBaseBloc>().state.userData,
                              context: context));
                        }),
                    const SizedBox(height: 15),
                    WidgetForLikeorDislike(
                        icon: Icons.report,
                        onTap: () {
                          context.read<HomeBloc>().add(
                              OnReportUser(context: context, userModel: user));
                        }),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "${user.firstName} ${user.lastName},",
                style: TextStyle(
                  color: theme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: '${user.age}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                  fontSize: 24,
                ),
              ),
            ])),
            Container(
              decoration: BoxDecoration(
                color: AppColors.redColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "${user.distance(context, null)} km",
                style: AppTextStyle.font16.copyWith(color: theme.textColor),
              ),
            )
          ],
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
    final theme = AppTheme.of(context);
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
                  description: "Swipe up and down to explore",
                  title: "Find Match",
                  tooltipPosition: TooltipPosition.bottom,
                  targetBorderRadius: BorderRadius.circular(40),
                  child: const SizedBox(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Showcaseview(
                      globalKey: key3,
                      description: "Click to see user info",
                      title: "Info",
                      tooltipPosition: TooltipPosition.top,
                      targetBorderRadius: BorderRadius.circular(40),
                      child: WidgetForLikeorDislike(
                          icon: Icons.info, onTap: () {}),
                    ),
                    const SizedBox(height: 15),
                    Showcaseview(
                      targetBorderRadius: BorderRadius.circular(40),
                      description: "Click to like user",
                      globalKey: key4,
                      tooltipPosition: TooltipPosition.top,
                      title: "Like",
                      child: WidgetForLikeorDislike(
                          icon: Icons.favorite, onTap: () {}),
                    ),
                    const SizedBox(height: 15),
                    Showcaseview(
                      targetBorderRadius: BorderRadius.circular(40),
                      description: "Click if you don't want to match",
                      globalKey: key5,
                      tooltipPosition: TooltipPosition.top,
                      title: "Not your match",
                      child: WidgetForLikeorDislike(
                          icon: Icons.remove, onTap: () {}),
                    ),
                    const SizedBox(height: 15),
                    Showcaseview(
                      targetBorderRadius: BorderRadius.circular(40),
                      description: "Click if you want to report user",
                      globalKey: key6,
                      tooltipPosition: TooltipPosition.top,
                      title: "Report",
                      child: WidgetForLikeorDislike(
                          icon: Icons.report, onTap: () {}),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "User name,",
                style: TextStyle(
                  color: theme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: '25',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                  fontSize: 24,
                ),
              ),
            ])),
            Container(
              decoration: BoxDecoration(
                color: AppColors.redColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "0 km",
                style: AppTextStyle.font16.copyWith(color: theme.textColor),
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
