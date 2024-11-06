import 'package:chat_with_bloc/model/filter_model.dart';

class FilterState {
  final num minAge;
  final num maxAge;
  final int gender;
  final int radius;
  final FilterModel filterModel;
  FilterState({
    required this.minAge,
    required this.maxAge,
    required this.gender,
    required this.radius,
    required this.filterModel,
  });

  FilterState copyWith({
    num? minAge,
    num? maxAge,
    int? gender,
    int? radius,
    FilterModel? filterModel,
  }) {
    return FilterState(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      gender: gender ?? this.gender,
      radius: radius ?? this.radius,
      filterModel: filterModel ?? this.filterModel,
    );
  }
}
