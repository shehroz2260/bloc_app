import 'package:bloc/bloc.dart';
import 'package:chat_with_bloc/model/report_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/network_service.dart';
import 'admin_report_event.dart';
import 'admin_report_state.dart';

class AdminReportBloc extends Bloc<AdminReportEvent, AdminReportState> {
  AdminReportBloc() : super(AdminReportState(reportList: [])) {
    on<OninitReports>(_oninitReports);
    on<ListenBlockUser>(_listenBlockUser);
  }
  _oninitReports(OninitReports event, Emitter<AdminReportState> emit) async {
    await FirebaseFirestore.instance
        .collection(ReportUserModel.tableName)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (final e in value.docs) {
          final report = ReportUserModel.fromMap(e.data());
          report.senderUser =
              await NetworkService.getUserDetailById(report.senderId);
          report.reportUser =
              await NetworkService.getUserDetailById(report.reportedUserId);
          state.reportList.add(report);
          emit(state.copyWith(reportList: state.reportList));
        }
      }
    });
  }

  _listenBlockUser(ListenBlockUser event, Emitter<AdminReportState> emit) {
    state.reportList[event.index].reportUser = state
        .reportList[event.index].reportUser!
        .copyWith(isVerified: event.val);
    emit(state.copyWith(reportList: state.reportList));
  }
}
