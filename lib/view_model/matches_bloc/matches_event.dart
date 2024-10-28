import '../../model/user_model.dart';
abstract class MatchesEvent {}

class ChangeIndex extends MatchesEvent {
  final int index;
  ChangeIndex({
    required this.index,
  });
}

class ONinit extends MatchesEvent {
  final UserModel bloc;
  ONinit({
    required this.bloc,
  });
}

class ClearList extends MatchesEvent {}