import 'package:flutter/material.dart';

class AppHeight extends StatelessWidget {
  final double height;
  const AppHeight({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class AppWidth extends StatelessWidget {
  final double width;
  const AppWidth({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
