// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';

class SignUpState {
  final File? image;
  final Color borderClr;
  SignUpState({
    this.image,
    required this.borderClr
  });

  SignUpState copyWith({
    File? image,
    Color? borderClr,
  }) {
    return SignUpState(
      image: image ?? this.image,
      borderClr: borderClr ?? this.borderClr,
    );
  }
 }
