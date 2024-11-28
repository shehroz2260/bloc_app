import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/bloc/admin_nav_bloc.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/bloc/admin_nav_state.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_bloc.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/custom_navigation_bar.dart';

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
              Expanded(
                  child: IndexedStack(
                index: state.currentIndex,
                children: const [],
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

  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant MyInheritedWidget oldWidget) {
    return false;
  }
}
