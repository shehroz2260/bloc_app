// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService {
  Future deleteFile(String url, BuildContext context) async {
  if ((url.isEmpty) || !url.contains("firebasestorage")) {
    return;
  }

  try {
    Reference photoRef = FirebaseStorage.instance.refFromURL(url);
    if (kDebugMode) {
      print(photoRef.fullPath);
    }
    if (photoRef.fullPath.isNotEmpty) await photoRef.delete();
  } on Exception catch (e) {
    showOkAlertDialog(context: context,message: e.toString(),title: "Error");
  }
}

Future<String> uploadImage(String uid, String path) async {
  Reference reference = FirebaseStorage.instance.ref().child(uid);
  UploadTask uploadTask = reference.putFile(File(path));
  TaskSnapshot snapshot = await uploadTask;
  var url = await snapshot.ref.getDownloadURL();
  return url;
}
}