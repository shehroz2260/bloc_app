// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_with_bloc/model/user_model.dart';

class MatchesState {
  final int index;
  final List<UserModel> likesList;
  final List<UserModel> matchedList;
  MatchesState({
    required this.index,
    required this.likesList,
    required this.matchedList,
  });

  MatchesState copyWith({
    int? index,
    List<UserModel>? likesList,
    List<UserModel>? matchedList,
  }) {
    return MatchesState(
      index: index ?? this.index,
      likesList: likesList ?? this.likesList,
      matchedList: matchedList ?? this.matchedList,
    );
  }
}
