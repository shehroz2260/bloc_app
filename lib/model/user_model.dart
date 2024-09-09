import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
   String? password;
  final String uid;
  final String location;
  final double lat;
  final double lng;
  final int gender;
  final int preferGender;
  final DateTime dob;
  final String profileImage;
  final List<String> myLikes;
  final List<String> myDislikes;
  final List<String> otherLikes;
  final List<String> otherDislikes;
  final List<String> matches;
  static const String tableName = "users";
  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.location,
    required this.lat,
    required this.lng,
    required this.gender,
    required this.preferGender,
    required this.dob,
    required this.profileImage,
    required this.myLikes,
    required this.myDislikes,
    required this.otherLikes,
    required this.otherDislikes,
    required this.matches,
  });

static UserModel get emptyModel {
  return UserModel(name: "", email: "", uid: "", location: "", lat: 0.0, lng: 0.0, gender: 0, preferGender: 0, dob: DateTime(1800), profileImage: "", myLikes: [], myDislikes: [], otherLikes: [], otherDislikes: [], matches: []);
}
  UserModel copyWith({
    String? name,
    String? email,
    String? uid,
    String? location,
    double? lat,
    double? lng,
    int? gender,
    int? preferGender,
    DateTime? dob,
    String? profileImage,
    List<String>? myLikes,
    List<String>? myDislikes,
    List<String>? otherLikes,
    List<String>? otherDislikes,
    List<String>? matches,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      location: location ?? this.location,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      gender: gender ?? this.gender,
      preferGender: preferGender ?? this.preferGender,
      dob: dob ?? this.dob,
      profileImage: profileImage ?? this.profileImage,
      myLikes: myLikes ?? this.myLikes,
      myDislikes: myDislikes ?? this.myDislikes,
      otherLikes: otherLikes ?? this.otherLikes,
      otherDislikes: otherDislikes ?? this.otherDislikes,
      matches: matches ?? this.matches,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'uid': uid,
      'location': location,
      'lat': lat,
      'lng': lng,
      'gender': gender,
      'preferGender': preferGender,
      'dob': Timestamp.fromDate(dob),
      'profileImage': profileImage,
      'myLikes': myLikes,
      'myDislikes': myDislikes,
      'otherLikes': otherLikes,
      'otherDislikes': otherDislikes,
      'matches': matches,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ??"",
      email: map['email'] ??"",
      uid: map['uid'] ??"",
      location: map['location'] ??"",
      lat: map['lat'] ??0.0,
      lng: map['lng'] ??0.0,
      gender: map['gender'] ??0,
      preferGender: map['preferGender'] ??-1,
      dob: (map['dob'] as Timestamp).toDate() ,
      profileImage: map['profileImage'] ??"",
      myLikes: List<String>.from((map['myLikes'] ??[])),
      myDislikes: List<String>.from((map['myDislikes'] ??[])),
      otherLikes: List<String>.from((map['otherLikes'] ??[])),
      otherDislikes: List<String>.from((map['otherDislikes'] ??[])),
      matches: List<String>.from((map['matches'] ??[])),
    );
  }
  int get age {
    return DateTime.now().difference(dob).inDays ~/ 365;
  }
  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, uid: $uid, location: $location, lat: $lat, lng: $lng, gender: $gender, preferGender: $preferGender, dob: $dob, profileImage: $profileImage, myLikes: $myLikes, myDislikes: $myDislikes, otherLikes: $otherLikes, otherDislikes: $otherDislikes, matches: $matches)';
  }

}
