import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/admin_home_bloc/admin_home_bloc.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/admin_reports_bloc/admin_report_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/admin_bloc/admin_home_bloc/admin_home_event.dart';
import '../../view_model/admin_bloc/admin_reports_bloc/admin_report_bloc.dart';
import '../../view_model/admin_bloc/admin_reports_bloc/admin_report_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminReportsView extends StatefulWidget {
  const AdminReportsView({super.key});

  @override
  State<AdminReportsView> createState() => _AdminReportsViewState();
}

class _AdminReportsViewState extends State<AdminReportsView> {
  @override
  void initState() {
    context.read<AdminReportBloc>().add(OninitReports());
    super.initState();
  }

  AdminReportBloc ancestorContext = AdminReportBloc();
  @override
  void didChangeDependencies() {
    ancestorContext = MyInheritedWidget(
            bloc: context.read<AdminReportBloc>(), child: const SizedBox())
        .bloc;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    ancestorContext.add(OnDisposeReport());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return BlocBuilder<AdminReportBloc, AdminReportState>(
        builder: (context, state) {
      return Column(
        children: [
          const AppHeight(height: 10),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: List.generate(state.reportList.length, (index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.borderGreyColor,
                      )),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("${AppLocalizations.of(context)!.reason}: ",
                              style: AppTextStyle.font16.copyWith(
                                  color: theme.textColor,
                                  fontWeight: FontWeight.w600)),
                          Text(state.reportList[index].messages.first,
                              style: AppTextStyle.font16.copyWith(
                                color: theme.textColor,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text("${AppLocalizations.of(context)!.reportBy}: ",
                              style: AppTextStyle.font16.copyWith(
                                  color: theme.textColor,
                                  fontWeight: FontWeight.w600)),
                          Text(
                              state.reportList[index].senderUser?.firstName ??
                                  "",
                              style: AppTextStyle.font16.copyWith(
                                color: theme.textColor,
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Text("Reported user: ",
                              style: AppTextStyle.font16.copyWith(
                                  color: theme.textColor,
                                  fontWeight: FontWeight.w600)),
                          Text(
                              state.reportList[index].reportUser?.firstName ??
                                  "",
                              style: AppTextStyle.font16.copyWith(
                                color: theme.textColor,
                              ))
                        ],
                      ),
                      const AppHeight(height: 10),
                      GestureDetector(
                        onTap: () {
                          final userIndex = context
                              .read<AdminHomeBloc>()
                              .state
                              .userList
                              .indexWhere((e) =>
                                  e.uid ==
                                  state.reportList[index].reportedUserId);
                          if (state.reportList[index].reportUser?.isVerified ??
                              false) {
                            context.read<AdminHomeBloc>().add(
                                OnChangeVerify(val: false, index: userIndex));
                            context
                                .read<AdminReportBloc>()
                                .add(ListenBlockUser(val: false, index: index));
                          } else {
                            context.read<AdminHomeBloc>().add(
                                OnChangeVerify(val: true, index: userIndex));
                            context
                                .read<AdminReportBloc>()
                                .add(ListenBlockUser(val: true, index: index));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: (state.reportList[index].reportUser
                                          ?.isVerified ??
                                      false)
                                  ? AppColors.redColor
                                  : AppColors.redColor
                                      .withAlpha((0.4 * 255).toInt())),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text(
                              (state.reportList[index].reportUser?.isVerified ??
                                      false)
                                  ? "Block ${state.reportList[index].reportUser?.firstName ?? ""}"
                                  : "Blocked",
                              style: AppTextStyle.font20),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ))
        ],
      );
    });
  }
}

class MyInheritedWidget extends InheritedWidget {
  final AdminReportBloc bloc;

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
