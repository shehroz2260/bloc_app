import 'package:flutter/material.dart';

class AppColors {
  static Color blackColor = Colors.black;
  static Color whiteColor = Colors.white;
  static Color offWhiteColor = const Color(0xffF3F3F3);
  static Color borderColor = const Color(0xffF3F3F3);
  static Color borderGreyColor = const Color(0xffE8E6EA);
  static Color redColor = const Color(0xffE94057);
  static Color blueColor = Colors.blue.shade600;
}

class AppTheme {
  static late Color backGround;

  oninFunc(bool isDark) {
    // context.read<ChangeThemeBloc>().stream.listen((state) async {
    //   if (state.currentTheme.brightness == Brightness.dark) {
    //     darkTheme();
    //   } else {
    //     lightTheme();
    //   }
    // });
    if (isDark) {
      darkTheme();
    } else {
      lightTheme();
    }
  }

  lightTheme() {
    backGround = Colors.white;
  }

  darkTheme() {
    backGround = Colors.black;
  }
}

class LightTheme extends AppTheme {
  Color get backGround => Colors.white;
}
