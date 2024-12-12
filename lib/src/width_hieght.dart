import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppHeight extends StatelessWidget {
  final double height;
  const AppHeight({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height.h);
  }
}

class AppWidth extends StatelessWidget {
  final double width;
  const AppWidth({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width.w);
  }
}
