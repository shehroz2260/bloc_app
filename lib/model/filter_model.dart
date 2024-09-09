
class FilterModel {
  final int minAge;
  final int maxAge;
  final int intrestedIn;
  final int distance;
  FilterModel({
    required this.minAge,
    required this.maxAge,
    required this.intrestedIn,
    required this.distance,
  });
static const String tableName = "filter";
  FilterModel copyWith({
    int? minAge,
    int? maxAge,
    int? intrestedIn,
    int? distance,
  }) {
    return FilterModel(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      intrestedIn: intrestedIn ?? this.intrestedIn,
      distance: distance ?? this.distance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'minAge': minAge,
      'maxAge': maxAge,
      'intrestedIn': intrestedIn,
      'distance': distance,
    };
  }

  factory FilterModel.fromMap(Map<String, dynamic> map) {
    return FilterModel(
      minAge: map['minAge'] ??-1,
      maxAge: map['maxAge'] ??-1,
      intrestedIn: map['intrestedIn'] ??-1,
      distance: map['distance'] ??-1,
    );
  }

  @override
  String toString() {
    return 'FilterModel(minAge: $minAge, maxAge: $maxAge, intrestedIn: $intrestedIn, distance: $distance)';
  }
}
