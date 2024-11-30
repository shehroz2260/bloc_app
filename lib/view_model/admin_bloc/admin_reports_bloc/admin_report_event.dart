abstract class AdminReportEvent {}

class OninitReports extends AdminReportEvent {}

class ListenBlockUser extends AdminReportEvent {
  final int index;
  final bool val;
  ListenBlockUser({
    required this.index,
    required this.val,
  });
}
