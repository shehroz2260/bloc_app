// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';

class AppFuncs {
static  String generateRandomString(int len) {
  var r = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}
  static String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final noTimeDate = DateTime(date.year, date.month, date.day);
    String formattedDate = today.difference(noTimeDate).inDays == 0
        ? "Today"
        : yesterday.difference(noTimeDate).inDays == 0
            ? "Yesterday"
            : DateFormat("MM/dd/yyyy").format(noTimeDate);
    return formattedDate;
  }
      static Future<File?> getCacheFile(String url, String id,BuildContext context) async {
    try {
      var olderFile = await DefaultCacheManager().getFileFromMemory(id);
      if (await olderFile?.file.exists() ?? false) return olderFile?.file;
      var oldFile = await DefaultCacheManager().getFileFromCache(id);
      if (await oldFile?.file.exists() ?? false) return oldFile?.file;
      final file = await DefaultCacheManager().getSingleFile(url, key: id);
      bool exist = await file.exists();
      if (exist) {
        return file;
      }
    } catch (e) {
      showOkAlertDialog(context: context,message: e.toString(),title: "Error");
    }

    return null;
  }
  static  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}