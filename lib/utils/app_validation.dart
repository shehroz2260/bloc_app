import '../src/app_string.dart';

class AppValidation {
   static String? emailValidation(String? value) {
   final regex = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if ((value ?? "").isEmpty) {
      return ErrorStrings.emailReq;
    }
    if (!regex.hasMatch(value??"")) {

      return ErrorStrings.emailInvalid;
    }

    return null;
  }

 static String? passwordValidation(String? value) {
    if ((value ?? "").isEmpty) {
      return ErrorStrings.passwordReq;
    }
    if ((value ?? "").length < 8) {
      return ErrorStrings.passwordContain8Char;
    }

    return null;
  }
 static String? nameValidation(String? value) {
    if ((value ?? "").isEmpty) {
      return ErrorStrings.nameReq;
    }
    return null;
  }
   static String? userNameValidation(String? value) {
    if ((value ?? "").isEmpty) {
      return ErrorStrings.usernameReq;
    }
    return null;
  }
 static String? dobValidation(String? value) {
    if ((value ?? "").isEmpty) {
      return ErrorStrings.birthDayReq;
    }
    return null;
  }

  static  String? descValidation(String? value) {
    if ((value ?? "").isEmpty) {
      
      return ErrorStrings.descReq;
    }
   
    return null;
  }
}