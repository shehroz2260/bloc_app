abstract class AdminNavEvent {}

class UpdateAdminNavIndex extends AdminNavEvent {
  final int index;
  UpdateAdminNavIndex({
    required this.index,
  });
}
