import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/bloc/story_bloc.dart';
import 'package:chat_with_bloc/view_model/bloc/story_event.dart';
import 'package:chat_with_bloc/view_model/bloc/story_state.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../src/app_text_style.dart';
import '../../../widgets/custom_button.dart';

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
    context.read<StoryBloc>().add(GetStory(context: context));
    super.initState();
  }

  @override
  void dispose() {
    storyBloc.add(OnDisposeStory());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: BlocBuilder<StoryBloc, StoryState>(builder: (context, state) {
            return Column(
              children: [
                const AppHeight(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(),
                    Text("Story",
                        style: AppTextStyle.font25
                            .copyWith(color: AppColors.blackColor)),
                    GestureDetector(
                      onTap: () => _openOptions(),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderColor),
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.add, color: AppColors.redColor)),
                    )
                  ],
                ),
                const AppHeight(height: 20),
                if (state.isLoading)
                  Expanded(
                      child: Center(
                    child: CircularProgressIndicator(color: AppColors.redColor),
                  )),
                if (!state.isLoading && state.storyList.isEmpty)
                  const Expanded(
                      child: Center(
                    child: Text("There is no story"),
                  )),
                if (!state.isLoading && state.storyList.isNotEmpty)
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(state.storyList.length, (index) {
                        return Text(state.storyList[index].userName);
                      }),
                    ),
                  ))
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
                  "Options",
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
                        "Video",
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
                        "Images",
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
