import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class LoadingDialog {
  static bool isAlreadyShow = false;


  void dismissKeyBoard() {}

  static void showProgress(BuildContext context) {
    if (isAlreadyShow) {
      return;
    }
    isAlreadyShow = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: AlertDialog(
                contentPadding: EdgeInsets.zero,
                titlePadding: EdgeInsets.symmetric(vertical: 15),
                insetPadding: EdgeInsets.zero,
                buttonPadding: EdgeInsets.zero,
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      NativeProgress(),
                      SizedBox(width: 20),
                      Text("Loading....")
                    ],
                  ),
                )),
          );
        });
  }

  static void hideProgress(BuildContext context) {
    try {
      if (LoadingDialog.isAlreadyShow) {
        LoadingDialog.isAlreadyShow = false;
        Navigator.pop(context);
      }
    } catch (e) {
      showOkAlertDialog(context: context,message: e.toString(),title: "Error");
    }
  }
}

class NativeProgress extends StatelessWidget {
  const NativeProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ?  Center(
            child: SizedBox(
                height: 30, width: 30, child: CircularProgressIndicator(color: AppColors.blueColor,)))
        : Center(
            child: Theme(
                data: ThemeData(
                    cupertinoOverrideTheme: const CupertinoThemeData(
                        brightness: Brightness.light,
                        primaryColor: Colors.white,
                        barBackgroundColor: Colors.white)),
                child: const CupertinoActivityIndicator()),
          );
  }
}
