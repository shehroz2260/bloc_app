import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/app_colors.dart';
import '../src/app_text_style.dart';
import '../src/width_hieght.dart';
import '../view_model/setting_bloc/setting_bloc.dart';
import '../view_model/setting_bloc/setting_event.dart';
import '../view_model/setting_bloc/setting_state.dart';

class SettiingWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onTap;
  final Color color;
  final bool isNotification;
  const SettiingWidget({
    super.key,
    this.isNotification = false,
    required this.icon,
    required this.title,
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
                child: Text(title,
                    style:
                        AppTextStyle.font20.copyWith(color: theme.textColor))),
            isNotification
                ? BlocBuilder<SettingBloc, SettingState>(
                    builder: (context, state) {
                    return Switch(
                        value: state.isOnNotification,
                        onChanged: (val) {
                          context.read<SettingBloc>().add(
                              OnNotificationEvent(isOn: val, context: context));
                        });
                  })
                : const Icon(Icons.arrow_forward_ios_outlined)
          ],
        ),
      ),
    );
  }
}
