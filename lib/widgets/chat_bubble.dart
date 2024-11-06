import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/app_funcs.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/chat_bloc.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/chat_event.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/widgets/image_preview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/char_model.dart';
import '../utils/media_type.dart';
import 'app_cache_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_video_player.dart';
import 'wave_bubble.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key,
      required this.data,
      required this.showTime,
      required this.userModel});
  final UserModel userModel;
  final bool showTime;
  final ChatModel data;

  @override
  Widget build(BuildContext context) {
    var isSender =
        data.senderId == context.read<UserBaseBloc>().state.userData.uid;
    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (showTime)
          Row(
            children: [
              const Expanded(
                child: Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      AppFuncs.getFormattedDate(data.messageTime.toLocal()))),
              const Expanded(
                child: Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
              ),
            ],
          ),
        data.media != null && (data.media?.type ?? 0) == MediaType.audio
            ? Padding(
                padding: EdgeInsets.only(
                    left: isSender ? 70 : 0, right: isSender ? 0 : 70),
                child: WaveBubble(
                  isFromNetwork: true,
                  path: data.media?.url ?? "",
                  id: data.media?.id ?? "",
                  isSender: isSender,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.black),
                  color: !isSender
                      ? AppColors.redColor.withOpacity(0.15)
                      : AppColors.borderGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: Radius.circular(isSender ? 12 : 0),
                      bottomRight: Radius.circular(isSender ? 0 : 12)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.only(
                  left: isSender ? 80 : 0,
                  right: isSender ? 0 : 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.media != null &&
                        (data.media?.type ?? 0) == MediaType.image)
                      Stack(
                        children: [
                          AppCacheImage(
                            imageUrl: data.media?.url ?? "",
                            onTap: () {
                              Go.to(context,
                                  ImagePreview(url: data.media?.url ?? ""));
                            },
                          ),
                          GestureDetector(
                              onTap: () {
                                context.read<ChatBloc>().add(DownloadMedia(
                                    context: context, chat: data));
                              },
                              child: Icon(Icons.download,
                                  color: AppColors.blueColor, size: 40)),
                        ],
                      ),
                    if (data.media != null &&
                        (data.media?.type ?? 0) == MediaType.video)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AppCacheImage(
                            imageUrl: data.media?.thumbnail ?? "",
                            onTap: () {
                              Go.to(context, TKVideoPlayer(media: data));
                            },
                          ),
                          Icon(Icons.download,
                              color: AppColors.blueColor, size: 40),
                          GestureDetector(
                              onTap: () {
                                Go.to(context, TKVideoPlayer(media: data));
                              },
                              child: const Icon(
                                Icons.play_circle_outline_rounded,
                                color: Colors.white,
                                size: 40,
                              ))
                        ],
                      ),
                    if ((data.media?.type ?? 0) == 5 && !isSender)
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "Click the id to join call: ",
                            style: TextStyle(color: AppColors.blackColor)),
                        TextSpan(
                            text: data.message,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Go.to(context, MyHomePage(threadId: "", isCreateRoom: false, roomId: data.message,userModel: userModel,));
                              },
                            style: TextStyle(color: AppColors.blueColor)),
                      ]))
                    else
                      SelectableText(data.message),
                  ],
                )),
        Text(DateFormat("hh:mm a").format(data.messageTime)),
        const SizedBox(
          height: 7,
        )
      ],
    );
  }
}
