import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/filter_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FilterRepo {
  static Future<void> setFilter(FilterModel model, BuildContext context)async{
    try{
await FirebaseFirestore.instance.collection(FilterModel.tableName).doc(FirebaseAuth.instance.currentUser?.uid??"").set(model.toMap());
    }on FirebaseException catch (e){
showOkAlertDialog(context: context, message: e.message,title: "Error");
    }
  }

    static Future<FilterModel> getFilter()async{
   
   final snapShot = await FirebaseFirestore.instance.collection(FilterModel.tableName).doc(FirebaseAuth.instance.currentUser?.uid??"").get();
  if(!snapShot.exists) return FilterModel(minAge: -1, maxAge: -1, intrestedIn: -1, distance: -1);
   return FilterModel.fromMap(snapShot.data()!);
  }
}