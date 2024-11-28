import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/model/report_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_report_event.dart';
import 'admin_report_state.dart';

class AdminReportBloc extends Bloc<AdminReportEvent, AdminReportState> {
  AdminReportBloc() : super(AdminReportState(reportList: [])) {
    on<OninitReports>(_oninitReports);
  }
  _oninitReports(OninitReports event, Emitter<AdminReportState> emit) async {
    await FirebaseFirestore.instance
        .collection(ReportUserModel.tableName)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        emit(state.copyWith(
            reportList: value.docs
                .map((e) => ReportUserModel.fromMap(e.data()))
                .toList()));
      }
    });
  }
}
