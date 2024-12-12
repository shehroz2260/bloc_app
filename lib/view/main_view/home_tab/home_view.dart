import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/utils/custom_dialogs.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_bloc.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_event.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_state.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/widgets/show_case_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../src/app_text_style.dart';
import '../../../src/width_hieght.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../widgets/home_card_widget.dart';

class HomeView extends StatefulWidget {
  final GlobalKey key1;
  final GlobalKey key2;
  final GlobalKey key3;
  final GlobalKey key4;
  final GlobalKey key5;
  final GlobalKey key6;
  final bool isVisited;
  const HomeView(
      {super.key,
      required this.key1,
      required this.key2,
      required this.key3,
      required this.key4,
      required this.isVisited,
      required this.key5,
      required this.key6});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    if (context.read<UserBaseBloc>().state.userData.isVerified) {
      context
          .read<HomeBloc>()
          .add(ONINITEvent(context: context, userBaseBloc: null));
    }
    super.initState();
  }

  UserBaseBloc ancestorContext = UserBaseBloc();
  @override
  void didChangeDependencies() {
    ancestorContext = MyInheritedWidget(
            bloc: context.read<UserBaseBloc>(), child: const SizedBox())
        .bloc;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(children: [
          const AppHeight(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 50),
                Text(AppLocalizations.of(context)!.discover,
                    style:
                        AppTextStyle.font25.copyWith(color: theme.textColor)),
                Showcaseview(
                  targetBorderRadius: BorderRadius.circular(20),
                  description: "Click to search people by filter",
                  globalKey: widget.key1,
                  title: "Filter",
                  child: GestureDetector(
                    onTap: () {
                      CustomDialogs.openFilterDialog(context, ancestorContext);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.borderGreyColor,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(AppAssets.filterIcon),
                    ),
                  ),
                )
              ],
            ),
          ),
          const AppHeight(height: 20),
          if (state.isLoading)
            Expanded(
                child: Center(
              child: CircularProgressIndicator(color: AppColors.redColor),
            )),
          if (!state.isLoading && !widget.isVisited)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: HomeCardForMessage(
                    key3: widget.key3,
                    key4: widget.key4,
                    key5: widget.key5,
                    key6: widget.key6,
                    key7: widget.key2),
              ),
            ),
          if (!state.isLoading && state.userList.isEmpty && widget.isVisited)
            Expanded(
                child: Center(
              child: Text(AppLocalizations.of(context)!.thereIsNoUsers,
                  style: AppTextStyle.font16
                      .copyWith(color: AppColors.blackColor)),
            )),
          if (!state.isLoading && state.userList.isNotEmpty && widget.isVisited)
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                      controller: PageController(),
                      scrollDirection: Axis.vertical,
                      itemCount: state.userList.length,
                      itemBuilder: (context, index) {
                        var user = state.userList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: AnimatedSwitcher(
                            transitionBuilder: (child, animation) {
                              return SlideTransition(
                                  position: Tween<Offset>(
                                          begin: const Offset(0, 1),
                                          end: const Offset(0, 0))
                                      .animate(animation),
                                  child: child);
                            },
                            duration: const Duration(milliseconds: 200),
                            child: Dismissible(
                              direction: DismissDirection.none,
                              movementDuration: const Duration(milliseconds: 1),
                              resizeDuration: const Duration(milliseconds: 1),
                              key: ValueKey(state.userList[index]),
                              child: HomeCard(user: user),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
        ]);
      },
    );
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
