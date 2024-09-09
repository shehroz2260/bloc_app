// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class MainEvent {}

class ChangeIndexEvent extends MainEvent {
final int index;
  ChangeIndexEvent({
    required this.index,
  });
}
