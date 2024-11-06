import 'package:flutter/material.dart';

class Go {
  static Future<void> offAll(BuildContext context, Widget child) async {
    await Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => child), (val) => false);
  }

  static Future<void> to(BuildContext context, Widget child) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => child));
  }

  static Future<void> off(BuildContext context, Widget child) async {
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => child));
  }

  static Future<void> back(BuildContext context) async {
    Navigator.pop(context);
  }
}
