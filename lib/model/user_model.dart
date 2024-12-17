import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class UserModel {
  final String lastName;
  final String firstName;
  final String email;
  final String fcmToken;
  final String phoneNumber;
  String? password;
  final String uid;
  final String location;
  final double lat;
  final double lng;
  final int gender;
  final int preferGender;
  final List<String> galleryImages;
  final String bio;
  final String about;
  final String cusId;
  final DateTime dob;
  final bool isOnline;
  final bool isAdmin;
  final bool ignitoMode;
  final bool isShowLocation;
  final bool isVerified;
  final bool isOnNotification;
  final String profileImage;
  final List<String> myLikes;
  final List<String> myDislikes;
  final List<int> myInstrest;
  final List<String> otherLikes;
  final List<String> otherDislikes;
  final List<String> matches;
  UserModel({
    required this.bio,
    required this.isVerified,
    required this.isShowLocation,
    required this.isOnNotification,
    required this.ignitoMode,
    required this.galleryImages,
    required this.lastName,
    required this.about,
    required this.fcmToken,
    required this.cusId,
    required this.phoneNumber,
    required this.isOnline,
    required this.myInstrest,
    required this.firstName,
    required this.isAdmin,
    required this.email,
    this.password,
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
  static const String tableName = "users";

  UserModel copyWith({
    String? lastName,
    String? firstName,
    String? email,
    String? uid,
    String? about,
    String? fcmToken,
    String? bio,
    String? phoneNumber,
    String? cusId,
    String? location,
    double? lat,
    double? lng,
    int? gender,
    int? preferGender,
    DateTime? dob,
    bool? isOnline,
    bool? isAdmin,
    bool? isShowLocation,
    bool? isVerified,
    bool? ignitoMode,
    bool? isOnNotification,
    String? profileImage,
    List<String>? myLikes,
    List<String>? galleryImages,
    List<int>? myInstrest,
    List<String>? myDislikes,
    List<String>? otherLikes,
    List<String>? otherDislikes,
    List<String>? matches,
  }) {
    return UserModel(
      lastName: lastName ?? this.lastName,
      isShowLocation: isShowLocation ?? this.isShowLocation,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      galleryImages: galleryImages ?? this.galleryImages,
      bio: bio ?? this.bio,
      isAdmin: isAdmin ?? this.isAdmin,
      fcmToken: fcmToken ?? this.fcmToken,
      isOnNotification: isOnNotification ?? this.isOnNotification,
      cusId: cusId ?? this.cusId,
      about: about ?? this.about,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
      myInstrest: myInstrest ?? this.myInstrest,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      location: location ?? this.location,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      ignitoMode: ignitoMode ?? this.ignitoMode,
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
      'lastName': lastName,
      'firstName': firstName,
      'myInstrest': myInstrest,
      'email': email,
      'isOnline': isOnline,
      'cusId': cusId,
      'uid': uid,
      'fcmToken': fcmToken,
      'location': location,
      'lat': lat,
      'lng': lng,
      'isAdmin': isAdmin,
      'isVerified': isVerified,
      'gender': gender,
      'galleryImages': galleryImages,
      'bio': bio,
      'ignitoMode': ignitoMode,
      'isShowLocation': isShowLocation,
      'about': about,
      'preferGender': preferGender,
      'phoneNumber': phoneNumber,
      'dob': Timestamp.fromDate(dob),
      'profileImage': profileImage,
      'myLikes': myLikes,
      'myDisLikes': myDislikes,
      'otherLikes': otherLikes,
      'otherDislikes': otherDislikes,
      'isOnNotification': isOnNotification,
      'matches': matches,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      lastName: map['lastName'] ?? "",
      about: map['about'] ?? "",
      fcmToken: map['fcmToken'] ?? "",
      phoneNumber: map['phoneNumber'] ?? "",
      cusId: map['cusId'] ?? "",
      bio: map['bio'] ?? "",
      firstName: map['firstName'] ?? "",
      email: map['email'] ?? "",
      uid: map['uid'] ?? "",
      location: map['location'] ?? "",
      lat: map['lat'] ?? 0.0,
      lng: map['lng'] ?? 0.0,
      gender: map['gender'] ?? 0,
      isOnline: map['isOnline'] ?? false,
      ignitoMode: map['ignitoMode'] ?? false,
      isShowLocation: map['isShowLocation'] ?? true,
      isVerified: map['isVerified'] ?? true,
      isAdmin: map['isAdmin'] ?? false,
      isOnNotification: map['isOnNotification'] ?? false,
      preferGender: map['preferGender'] ?? 0,
      dob: (map['dob'] as Timestamp).toDate(),
      profileImage: (map['profileImage'] ?? "").isEmpty
          ? "https://ui-avatars.com/api/?background=random&name=${(map['firstName'] ?? "")}&size=200"
          : map["profileImage"],
      galleryImages: List<String>.from((map['galleryImages'] ?? [])),
      myLikes: List<String>.from((map['myLikes'] ?? [])),
      myInstrest: List<int>.from((map['myInstrest'] ?? [])),
      myDislikes: List<String>.from((map['myDisLikes'] ?? [])),
      otherLikes: List<String>.from((map['otherLikes'] ?? [])),
      otherDislikes: List<String>.from((map['otherDislikes'] ?? [])),
      matches: List<String>.from((map['matches'] ?? [])),
    );
  }

  int get age {
    return DateTime.now().difference(dob).inDays ~/ 365;
  }

  int distance(BuildContext context, UserBaseBloc? bloc) {
    UserModel user = UserModel.emptyModel;
    if (bloc == null) {
      user = context.read<UserBaseBloc>().state.userData;
    } else {
      user = bloc.state.userData;
    }
    if (user.lat == 0 || user.lng == 0) {
      return 232323232;
    }

    return ((Geolocator.distanceBetween(lat, lng, user.lat, user.lng)) * 0.001)
        .toInt();
  }

  bool isLiked(String uid) {
    if (myLikes.isEmpty) {
      return false;
    }

    return myLikes.contains(uid);
  }

  static UserModel get emptyModel {
    return UserModel(
        phoneNumber: "",
        about: "",
        bio: "",
        galleryImages: [],
        isOnline: false,
        isShowLocation: true,
        isAdmin: false,
        isVerified: false,
        ignitoMode: false,
        isOnNotification: false,
        myInstrest: [],
        lastName: "",
        firstName: "",
        fcmToken: "",
        cusId: "",
        email: "",
        uid: "",
        location: "",
        lat: 0.0,
        lng: 0.0,
        gender: 0,
        preferGender: 0,
        dob: DateTime(1800),
        profileImage: "",
        myLikes: [],
        myDislikes: [],
        otherLikes: [],
        otherDislikes: [],
        matches: []);
  }

  bool isDisLiked(String uid) {
    if (myDislikes.isEmpty) {
      return false;
    }
    return myDislikes.contains(uid);
  }

  @override
  String toString() {
    return 'UserModel(lastName: $lastName, ignitoMode: $ignitoMode, isShowLocation: $isShowLocation, isVerified: $isVerified, isAdmin: $isAdmin, fcmToken: $fcmToken, isOnNotification: $isOnNotification, cusId: $cusId, phoneNumber: $phoneNumber, galleryImages: $galleryImages, bio: $bio, about: $about, isOnline: $isOnline, myInstrest: $myInstrest, first1Name: $firstName, email: $email, password: $password, uid: $uid, location: $location, lat: $lat, lng: $lng, gender: $gender, preferGender: $preferGender, dob: $dob, profileImage: $profileImage, myLikes: $myLikes, myDislikes: $myDislikes, otherLikes: $otherLikes, otherDislikes: $otherDislikes, matches: $matches)';
  }
}
