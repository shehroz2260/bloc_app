import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../model/thread_model.dart';
import '../src/app_colors.dart';
import '../src/app_text_style.dart';
import '../src/go_file.dart';
import '../src/width_hieght.dart';
import '../view/main_view/chat_tab/chat_view.dart';
import 'app_cache_image.dart';
import 'image_view.dart';

class ThreadWidget extends StatelessWidget {
  final ThreadModel threadModel;
  const ThreadWidget({
    super.key,
    required this.threadModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        Go.to(context, ChatScreen(model: threadModel));
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            AppCacheImage(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: AppCacheImage(
                            imageUrl:
                                threadModel.userDetail?.profileImage ?? "",
                            height: 400,
                            boxFit: BoxFit.fitWidth,
                            onTap: () {
                              Go.off(
                                  context,
                                  ImageView(
                                      imageUrl: threadModel
                                              .userDetail?.profileImage ??
                                          ""));
                            },
                          ),
                        );
                      });
                },
                imageUrl: threadModel.userDetail?.profileImage ?? "",
                height: 60,
                width: 60,
                round: 60),
            const AppWidth(width: 10),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              threadModel.userDetail?.firstName ?? "",
                              style: AppTextStyle.font16.copyWith(
                                  color: theme.textColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                                threadModel.lastMessage.isEmpty
                                    ? AppLocalizations.of(context)!
                                        .sendYourFirstMessage
                                    : threadModel.lastMessage,
                                maxLines: 1,
                                style: AppTextStyle.font16.copyWith(
                                    color: theme.textColor, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            timeago.format(
                              threadModel.lastMessageTime,
                              locale: 'en_short',
                            ),
                          ),
                          if (threadModel.senderId !=
                                  (FirebaseAuth.instance.currentUser?.uid ??
                                      "") &&
                              threadModel.messageCount != 0)
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.redColor,
                              ),
                              child: Text(
                                threadModel.messageCount.toString(),
                                style: TextStyle(
                                    color: theme.textColor, fontSize: 10),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 1.5,
                    color: AppColors.borderGreyColor,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
