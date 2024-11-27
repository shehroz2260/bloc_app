import 'package:chat_with_bloc/services/local_storage_service.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_bloc.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_event.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../widgets/custom_navigation_bar.dart';
import 'chat_tab/inbox_view.dart';
import 'home_tab/home_view.dart';
import 'match_tab/match_view.dart';
import 'profile_tab/profile_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final GlobalKey key1 = GlobalKey();
  final GlobalKey key2 = GlobalKey();
  final GlobalKey key3 = GlobalKey();
  final GlobalKey key4 = GlobalKey();
  final GlobalKey key5 = GlobalKey();
  final GlobalKey key6 = GlobalKey();
  final GlobalKey key7 = GlobalKey();
  final GlobalKey key8 = GlobalKey();
  final GlobalKey key9 = GlobalKey();
  BuildContext? showcaseContext;
  bool isVisited = false;
  @override
  void initState() {
    setState(() {
      isVisited =
          LocalStorageService.storage.read(LocalStorageService.navigationKey) ??
              false;
    });
    if (!isVisited) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(showcaseContext!).startShowCase([
          key1,
          key2,
          key3,
          key4,
          key5,
          key6,
          key7,
          key8,
          key9,
        ]);
      });
    }
    context.read<MainBloc>().add(ListernerChanges(context: context));
    context.read<MainBloc>().add(OninitNotification(context: context));

    super.initState();
  }

  MainBloc ancestorContext = MainBloc();
  @override
  void didChangeDependencies() {
    ancestorContext = MyInheritedWidget(
            bloc: context.read<MainBloc>(), child: const SizedBox())
        .bloc;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    ancestorContext.add(OnDispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: ShowCaseWidget(onComplete: (p0, p1) {
        if (p0 == 8) {
          setState(() {
            isVisited = true;
          });
          LocalStorageService.storage
              .write(LocalStorageService.navigationKey, true);
        }
      }, builder: (showContext) {
        showcaseContext = showContext;
        return BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                    child: IndexedStack(
                  index: state.currentIndex,
                  children: [
                    HomeView(
                        key1: key1,
                        isVisited: isVisited,
                        key2: key2,
                        key3: key3,
                        key4: key4,
                        key5: key5,
                        key6: key6),
                    //  MapScreen(),
                    MatchTab(
                        index: state.currentIndex,
                        key: ValueKey(state.currentIndex == 1)),
                    const InboxView(),
                    ProfileView(
                        index: state.currentIndex,
                        key: ValueKey(state.currentIndex == 3)),
                  ],
                )),
                CustomNavigationBar(
                    key7: key7,
                    key8: key8,
                    key9: key9,
                    ontap: _onIndexChange,
                    currentIndex: state.currentIndex)
              ],
            );
          },
        );
      }),
    );
  }

  void _onIndexChange(int index) {
    context.read<MainBloc>().add(ChangeIndexEvent(index: index));
  }
}

class MyInheritedWidget extends InheritedWidget {
  final MainBloc bloc;

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
