import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/admin_inbox_bloc/admin_inbox_bloc.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/admin_inbox_bloc/admin_inbox_event.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/admin_inbox_bloc/admin_inbox_state.dart';
import 'package:chat_with_bloc/widgets/thread_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminInboxView extends StatefulWidget {
  const AdminInboxView({super.key});

  @override
  State<AdminInboxView> createState() => _AdminInboxViewState();
}

class _AdminInboxViewState extends State<AdminInboxView> {
  @override
  void initState() {
    context.read<AdminInboxBloc>().add(ThreadListener(context: context));
    super.initState();
  }

  AdminInboxBloc ancestorContext = AdminInboxBloc();
  @override
  void didChangeDependencies() {
    ancestorContext = MyInheritedWidget(
            bloc: context.read<AdminInboxBloc>(), child: const SizedBox())
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
    return BlocBuilder<AdminInboxBloc, AdminInboxState>(
        builder: (context, state) {
      return Column(
        children: [
          const AppHeight(height: 10),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: List.generate(state.adminThreadList.length, (index) {
                  return ThreadWidget(
                      threadModel: state.adminThreadList[index]);
                }),
              ),
            ),
          ))
        ],
      );
    });
  }
}

class MyInheritedWidget extends InheritedWidget {
  final AdminInboxBloc bloc;

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
