import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/media_type.dart';
import 'package:chat_with_bloc/view_model/story_bloc/story_bloc.dart';
import 'package:chat_with_bloc/view_model/story_bloc/story_event.dart';
import 'package:chat_with_bloc/view_model/story_bloc/story_state.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../src/app_text_style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/story_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StoryView extends StatefulWidget {
  const StoryView({super.key});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  UserBaseBloc ancestorContext = UserBaseBloc();
  StoryBloc storyBloc = StoryBloc();
  @override
  void didChangeDependencies() {
    ancestorContext = MyInheritedWidget(
            bloc: context.read<UserBaseBloc>(), child: const SizedBox())
        .bloc;
    storyBloc =
        StoryDispose(bloc: context.read<StoryBloc>(), child: const SizedBox())
            .bloc;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    context.read<StoryBloc>().add(FetchOthetStories(
        userModel: context.read<UserBaseBloc>().state.userData,
        context: context));
    super.initState();
  }

  @override
  void dispose() {
    storyBloc.add(OnDisposeStory());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      key: scaffoldMessengerKey,
      backgroundColor: theme.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: BlocBuilder<StoryBloc, StoryState>(builder: (context, state) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppHeight(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomBackButton(),
                        Text(AppLocalizations.of(context)!.story,
                            style: AppTextStyle.font25
                                .copyWith(color: theme.textColor)),
                        const SizedBox(
                          width: 55,
                        )
                      ],
                    ),
                    const AppHeight(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _openOptions,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: AppColors.redColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: theme.textColor)),
                              ),
                              Icon(
                                Icons.add,
                                color: AppColors.whiteColor,
                              )
                            ],
                          ),
                        ),
                        const AppWidth(width: 10),
                        if (state.storyList.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              Go.to(context,
                                  CustomStoryView(mediaList: state.storyList));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.redColor,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: AppColors.redColor)),
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: AppCacheImage(
                                  imageUrl:
                                      state.storyList[0].type == MediaType.image
                                          ? state.storyList[0].url
                                          : state.storyList[0].thumbnail,
                                  round: 50,
                                  boxFit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(context.read<UserBaseBloc>().state.userData.firstName),
                    const AppHeight(height: 20),
                    Text(AppLocalizations.of(context)!.otherStories),
                    const AppHeight(height: 10),
                    if (state.otherList.isEmpty)
                      Expanded(
                          child: Center(
                        child:
                            Text(AppLocalizations.of(context)!.thereIsNoStory),
                      )),
                    if (state.otherList.isNotEmpty)
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children:
                              List.generate(state.otherList.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                Go.to(
                                    context,
                                    CustomStoryView(
                                        mediaList:
                                            state.otherList[index].list));
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.redColor),
                                      padding: const EdgeInsets.all(3),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.whiteColor),
                                        padding: const EdgeInsets.all(2),
                                        child: AppCacheImage(
                                            imageUrl: state
                                                .otherList[index].userImage,
                                            height: 50,
                                            width: 50,
                                            round: 50),
                                      ),
                                    ),
                                    const AppWidth(width: 10),
                                    Text(state.otherList[index].userName,
                                        style:
                                            TextStyle(color: theme.textColor)),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ))
                  ],
                ),
                if (state.isLoading)
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: AppColors.whiteColor.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.redColor,
                      ),
                    ),
                  )
              ],
            );
          }),
        ),
      ),
    );
  }

  void _openOptions() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.options,
                  style:
                      AppTextStyle.font25.copyWith(color: AppColors.redColor),
                ),
                GestureDetector(
                  onTap: () async {
                    await Go.back(context);
                    if (scaffoldMessengerKey.currentContext != null) {
                      scaffoldMessengerKey.currentContext!
                          .read<StoryBloc>()
                          .add(PickFile(
                              isVideo: true,
                              context: scaffoldMessengerKey.currentContext!,
                              bloc: ancestorContext));
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.video_camera_back,
                          color: AppColors.redColor, size: 40),
                      const AppWidth(width: 20),
                      Text(
                        AppLocalizations.of(context)!.video,
                        style: AppTextStyle.font25
                            .copyWith(color: AppColors.blackColor),
                      )
                    ],
                  ),
                ),
                const AppHeight(height: 30),
                GestureDetector(
                  onTap: () async {
                    Go.back(context);
                    if (mounted) {
                      context.read<StoryBloc>().add(PickFile(
                          isVideo: false,
                          context: context,
                          bloc: ancestorContext));
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt,
                          color: AppColors.redColor, size: 40),
                      const AppWidth(width: 20),
                      Text(
                        AppLocalizations.of(context)!.images,
                        style: AppTextStyle.font25
                            .copyWith(color: AppColors.blackColor),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class MyInheritedWidget extends InheritedWidget {
  final UserBaseBloc bloc;

  const MyInheritedWidget({
    super.key,
    required this.bloc,
    required super.child,
  });

  // Access the BLoC from the widget tree.
  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant MyInheritedWidget oldWidget) {
    // Notify when the BLoC changes (not needed here because BLoC is the same).
    return false;
  }
}

class StoryDispose extends InheritedWidget {
  final StoryBloc bloc;

  const StoryDispose({
    super.key,
    required this.bloc,
    required super.child,
  });

  // Access the BLoC from the widget tree.
  static StoryDispose? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoryDispose>();
  }

  @override
  bool updateShouldNotify(covariant StoryDispose oldWidget) {
    // Notify when the BLoC changes (not needed here because BLoC is the same).
    return false;
  }
}
