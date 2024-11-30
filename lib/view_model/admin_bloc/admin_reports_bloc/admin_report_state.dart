import 'package:chat_with_bloc/model/report_user_model.dart';

class AdminReportState {
  final List<ReportUserModel> reportList;
  AdminReportState({
    required this.reportList,
  });

  AdminReportState copyWith({
    List<ReportUserModel>? reportList,
  }) {
    return AdminReportState(
      reportList: reportList ?? this.reportList,
    );
  }
}
