import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/admin_bloc/admin_reports_bloc/admin_report_bloc.dart';
import '../../view_model/admin_bloc/admin_reports_bloc/admin_report_event.dart';

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

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [AppHeight(height: 60)],
    );
  }
}
