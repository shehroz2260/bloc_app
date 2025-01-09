import 'package:flutter/material.dart';
import '../src/app_colors.dart';
import '../src/app_text_style.dart';
import '../src/width_hieght.dart';

class SettiingWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subTitle;
  final void Function() onTap;
  final Color color;
  final bool isNotification;
  final bool isVAlueOn;
  final void Function(bool val)? onVAlueChanged;
  const SettiingWidget({
    super.key,
    this.isNotification = false,
    this.isVAlueOn = false,
    required this.icon,
    this.subTitle,
    required this.title,
    this.onVAlueChanged,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: AppColors.whiteColor),
            ),
            const AppWidth(width: 12),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        AppTextStyle.font20.copyWith(color: theme.textColor)),
                if ((subTitle ?? "").isNotEmpty)
                  Text(subTitle ?? "",
                      style: AppTextStyle.font16
                          .copyWith(color: theme.textColor, fontSize: 12)),
              ],
            )),
            isNotification
                ? Switch(value: isVAlueOn, onChanged: onVAlueChanged)
                : const Icon(Icons.arrow_forward_ios_outlined)
          ],
        ),
      ),
    );
  }
}
