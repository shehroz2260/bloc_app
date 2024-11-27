import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class Showcaseview extends StatelessWidget {
  final GlobalKey globalKey;
  final String description;
  final String? title;
  final Widget child;
  final BorderRadius? targetBorderRadius;
  final ShapeBorder? shapeBorder;
  final TooltipPosition? tooltipPosition;
  final EdgeInsets? padding;

  const Showcaseview(
      {super.key,
      this.padding,
      this.tooltipPosition,
      required this.globalKey,
      required this.description,
      this.title,
      required this.child,
      this.shapeBorder,
      this.targetBorderRadius});

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: globalKey,
      description: description,
      title: title,
      targetBorderRadius: targetBorderRadius,
      tooltipPadding: padding ?? const EdgeInsets.all(8),
      tooltipPosition: tooltipPosition,
      disableMovingAnimation: true,
      targetPadding: const EdgeInsets.all(0),
      child: child,
    );
  }
}
