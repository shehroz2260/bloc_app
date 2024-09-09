// ignore_for_file: use_build_context_synchronously

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  final Permission permission;
  final String permissionName;
  final BuildContext context;

  PermissionUtils(
      {required this.permission,
      required this.permissionName,
      required this.context});

  Future<bool> get isAllowed async {
    var startTime = DateTime.now();
    var status = await permission.request();
    var endTime = DateTime.now();
    var waitTime = startTime.difference(endTime).inSeconds.abs();

    /*   if (Platform.isIOS && status.isLimited && permission == Permission.photos) {
      return true;
    } */
    String messages = "";
    if (permission.value == Permission.location.value) {
      messages = "Please turn on precise location.";
    }
    // if (!status.isGranted && (status.isDenied || status.isPermanentlyDenied)) {
    if (/*!status.isGranted || status.isDenied || */ status
            .isPermanentlyDenied &&
        waitTime <= 1) {
      var result = await showOkCancelAlertDialog(
          context: context,
          title: "Permission Error",
          message:
              "You denied permission. Please allow $permissionName permission from setting.${messages}Open setting now?",
          okLabel: "Yes",
          cancelLabel: "No");
      if (result == OkCancelResult.ok) {
        openAppSettings();
      }
      return false;
    }

    return status.isGranted;
  }
}
