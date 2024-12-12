import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/admin_view/admin_home_view.dart';
import 'package:chat_with_bloc/view/admin_view/admin_inbox_view.dart';
import 'package:chat_with_bloc/view/admin_view/admin_reports_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/profile_view.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/admin_nav_bloc/admin_nav_bloc.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/admin_nav_bloc/admin_nav_event.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/admin_nav_bloc/admin_nav_state.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_bloc.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../src/app_text_style.dart';
import '../../widgets/custom_navigation_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminNavView extends StatefulWidget {
  const AdminNavView({super.key});

  @override
  State<AdminNavView> createState() => _AdminNavViewState();
}

class _AdminNavViewState extends State<AdminNavView> {
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
      body: BlocBuilder<AdminNavBloc, AdminNavState>(
        builder: (context, state) {
          return Column(
            children: [
              if (state.currentIndex != 3) const AppHeight(height: 60),
              if (state.currentIndex != 3)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          state.currentIndex == 0
                              ? AppLocalizations.of(context)!.allUsers
                              : state.currentIndex == 1
                                  ? AppLocalizations.of(context)!.reports
                                  : state.currentIndex == 2
                                      ? AppLocalizations.of(context)!.messages
                                      : "",
                          style: AppTextStyle.font25
                              .copyWith(color: theme.textColor)),
                    ],
                  ),
                ),
              Expanded(
                  child: IndexedStack(
                index: state.currentIndex,
                children: const [
                  AdminHomeView(),
                  AdminReportsView(),
                  AdminInboxView(),
                  ProfileView(index: 0),
                ],
              )),
              CustomAdminNavigationBar(
                  ontap: _onIndexChange, currentIndex: state.currentIndex)
            ],
          );
        },
      ),
    );
  }

  void _onIndexChange(int index) {
    context.read<AdminNavBloc>().add(UpdateAdminNavIndex(index: index));
  }
}

class MyInheritedWidget extends InheritedWidget {
  final MainBloc bloc;

  const MyInheritedWidget({
    super.key,
    required this.bloc,
    required super.child,
  });

  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant MyInheritedWidget oldWidget) {
    return false;
  }
}
