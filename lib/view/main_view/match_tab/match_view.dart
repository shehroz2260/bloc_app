import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/view/main_view/chat_tab/chat_view.dart';
import 'package:chat_with_bloc/view/main_view/match_tab/user_profile_view/user_profile_view.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_bloc.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_state.dart';
import 'package:chat_with_bloc/view_model/matches_bloc/matches_bloc.dart';
import 'package:chat_with_bloc/view_model/matches_bloc/matches_event.dart';
import 'package:chat_with_bloc/view_model/matches_bloc/matches_state.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/show_case_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../services/local_storage_service.dart';
import '../../../src/app_colors.dart';
import '../../../src/app_text_style.dart';
import '../../../src/width_hieght.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MatchTab extends StatefulWidget {
  final int index;
  const MatchTab({super.key, required this.index});

  @override
  State<MatchTab> createState() => _MatchTabState();
}

class _MatchTabState extends State<MatchTab> {
  final GlobalKey key1 = GlobalKey();
  final GlobalKey key2 = GlobalKey();
  bool isVisited = false;
  BuildContext? showcaseContext;
  @override
  void initState() {
    isVisited =
        LocalStorageService.storage.read(LocalStorageService.matchedTabKey) ??
            false;

    if (!isVisited && widget.index == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(showcaseContext!).startShowCase([key1, key2]);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return ShowCaseWidget(onComplete: (p0, p1) {
      if (p0 == 1) {
        LocalStorageService.storage
            .write(LocalStorageService.matchedTabKey, true);
      }
    }, builder: (context) {
      showcaseContext = context;
      return BlocBuilder<MatchesBloc, MatchesState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeight(height: 60),
              Text(
                  state.index == 0
                      ? AppLocalizations.of(context)!.likes
                      : AppLocalizations.of(context)!.matches,
                  style: AppTextStyle.font25.copyWith(color: theme.textColor)),
              const AppHeight(height: 20),
              BlocBuilder<UserBaseBloc, UserBaseState>(
                  builder: (context, userState) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Showcaseview(
                        description:
                            "Click this tab to see who likes your profile",
                        globalKey: key1,
                        title: "Likes",
                        tooltipPosition: TooltipPosition.bottom,
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<MatchesBloc>()
                                .add(ChangeIndex(index: 0));
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: state.index == 0
                                        ? AppColors.redColor
                                        : AppColors.whiteColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: state.index == 0
                                            ? AppColors.redColor
                                            : AppColors.borderGreyColor)),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.favorite,
                                  color: state.index == 0
                                      ? AppColors.whiteColor
                                      : AppColors.redColor,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.likes,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: state.index == 0
                                        ? AppColors.redColor
                                        : AppColors.blackColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const AppWidth(width: 15),
                      Showcaseview(
                        description: "Click this tab to see your matched",
                        globalKey: key2,
                        title: "matched",
                        tooltipPosition: TooltipPosition.bottom,
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<MatchesBloc>()
                                .add(ChangeIndex(index: 1));
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: state.index == 1
                                        ? AppColors.redColor
                                        : AppColors.whiteColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: state.index == 1
                                            ? AppColors.redColor
                                            : AppColors.borderGreyColor)),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  "assets/images/svg/message.svg",
                                  colorFilter: ColorFilter.mode(
                                      state.index == 1
                                          ? AppColors.whiteColor
                                          : AppColors.redColor,
                                      BlendMode.srcIn),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.connected,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: state.index == 1
                                        ? AppColors.redColor
                                        : AppColors.blackColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (state.index == 0)
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.7),
                      itemCount: state.likesList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              AppCacheImage(
                                imageUrl: state.likesList[index].profileImage,
                                round: 15,
                                width: double.infinity,
                                height: double.infinity,
                                boxFit: BoxFit.cover,
                                onTap: () {
                                  Go.to(
                                      context,
                                      UserProfileView(
                                          user: state.likesList[index]));
                                },
                              ),
                              if (state.likesList[index].matches.contains(
                                  FirebaseAuth.instance.currentUser?.uid ?? ""))
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.whiteColor),
                                    padding: const EdgeInsets.all(15),
                                    child: SvgPicture.asset(
                                      AppAssets.heart,
                                      colorFilter: ColorFilter.mode(
                                          AppColors.redColor, BlendMode.srcIn),
                                    ),
                                  ),
                                ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                              state.likesList[index].firstName,
                                              style: AppTextStyle.font20
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                ),
              if (state.index == 1)
                Expanded(
                  child: BlocBuilder<InboxBloc, InboxState>(
                      builder: (context, inboxState) {
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.7),
                        itemCount: inboxState.threadList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                AppCacheImage(
                                  imageUrl: inboxState.threadList[index]
                                          .userDetail?.profileImage ??
                                      "",
                                  round: 15,
                                  width: double.infinity,
                                  height: double.infinity,
                                  boxFit: BoxFit.cover,
                                  onTap: () {
                                    Go.to(
                                        context,
                                        UserProfileView(
                                            user: inboxState.threadList[index]
                                                    .userDetail ??
                                                UserModel.emptyModel));
                                  },
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                                inboxState
                                                        .threadList[index]
                                                        .userDetail
                                                        ?.firstName ??
                                                    "",
                                                style: AppTextStyle.font20
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          )),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: () async {
                                                    var okCancelResult =
                                                        await showOkCancelAlertDialog(
                                                            context: context,
                                                            message: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .doYouReallyWantToRemoveMatch,
                                                            title: AppLocalizations
                                                                    .of(context)!
                                                                .removeMatch);
                                                    if (okCancelResult ==
                                                        OkCancelResult.cancel) {
                                                      return;
                                                    }
                                                    NetworkService
                                                        .deleteConversation(
                                                            inboxState
                                                                    .threadList[
                                                                index],
                                                            inboxState
                                                                .threadList[
                                                                    index]
                                                                .threadId);
                                                    NetworkService.disLikeUser(
                                                        context
                                                            .read<
                                                                UserBaseBloc>()
                                                            .state
                                                            .userData,
                                                        inboxState
                                                            .threadList[index]
                                                            .userDetail!);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            14),
                                                    child: SvgPicture.asset(
                                                        AppAssets.cancelICon,
                                                        height:
                                                            double.infinity),
                                                  ))),
                                          Container(
                                              height: double.infinity,
                                              width: 2,
                                              color: AppColors.borderGreyColor),
                                          Expanded(
                                              child: GestureDetector(
                                            onTap: () {
                                              Go.to(
                                                  context,
                                                  ChatScreen(
                                                      model: inboxState
                                                          .threadList[index]));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(14),
                                              child: SvgPicture.asset(
                                                "assets/images/svg/message.svg",
                                                height: double.infinity,
                                                colorFilter: ColorFilter.mode(
                                                    AppColors.whiteColor,
                                                    BlendMode.srcIn),
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  }),
                ),
            ],
          ),
        );
      });
    });
  }
}
