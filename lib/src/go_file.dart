import 'package:flutter/material.dart';

class Go {
  static void offAll(BuildContext context, Widget child){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> child), (val)=> false);
  }
  static void to(BuildContext context, Widget child){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> child));
  }
   static void off(BuildContext context, Widget child){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> child));
  }
    static void back(BuildContext context){
    Navigator.pop(context);
  }
}