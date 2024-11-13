import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppValidation {
  static String? emailValidation(String? value, BuildContext context) {
    final regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if ((value ?? "").isEmpty) {
      return AppLocalizations.of(context)!.emailReq;
    }
    if (!regex.hasMatch(value ?? "")) {
      return AppLocalizations.of(context)!.emailInvalid;
    }

    return null;
  }

  static String? passwordValidation(String? value, BuildContext context) {
    if ((value ?? "").isEmpty) {
      return AppLocalizations.of(context)!.passwordReq;
    }
    if ((value ?? "").length < 8) {
      return AppLocalizations.of(context)!.passwordContain8Char;
    }

    return null;
  }

  static String? nameValidation(String? value, BuildContext context) {
    if ((value ?? "").isEmpty) {
      return AppLocalizations.of(context)!.nameReq;
    }
    return null;
  }

  static String? userNameValidation(String? value, BuildContext context) {
    if ((value ?? "").isEmpty) {
      return AppLocalizations.of(context)!.usernameReq;
    }
    return null;
  }

  static String? dobValidation(String? value, BuildContext context) {
    if ((value ?? "").isEmpty) {
      return AppLocalizations.of(context)!.birthDayReq;
    }
    return null;
  }

  static String? descValidation(String? value, BuildContext context) {
    if ((value ?? "").isEmpty) {
      return AppLocalizations.of(context)!.descReq;
    }

    return null;
  }

  static String? bioValidation(String? value, BuildContext context) {
    if ((value ?? "").isEmpty) {
      return AppLocalizations.of(context)!.bioIsReq;
    }

    return null;
  }

  static String? aboutValidation(String? value, BuildContext context) {
    if ((value ?? "").isEmpty) {
      return AppLocalizations.of(context)!.aboutIsReq;
    }

    return null;
  }
}
