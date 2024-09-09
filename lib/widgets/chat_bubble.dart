import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/app_funcs.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/widgets/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/char_model.dart';
import '../utils/media_type.dart';
import 'app_cache_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_video_player.dart';
import 'wave_bubble.dart';
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.data, required this.showTime,
  });

  final bool showTime;
  final ChatModel data;

  @override
  Widget build(BuildContext context) {
    var isSender = data.senderId == context.read<UserBaseBloc>().state.userData.uid;
    return Column(
    
    crossAxisAlignment: isSender? CrossAxisAlignment.end: CrossAxisAlignment.start,
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
      child: Text(AppFuncs
          .getFormattedDate(data.messageTime.toLocal()))),
                      const Expanded(
    child: Divider(
      color: Colors.black,
      thickness: 1,
    ),
                      ),
                    ],
                  ),
                    data.media != null && (data.media?.type??0) == MediaType.audio?
             Padding(
               padding:  EdgeInsets.only(left: isSender? 70:0,right: isSender ? 0:70 ),
               child: WaveBubble(isFromNetwork: true, path: data.media?.url??"", id: data.media?.id??""),
             ):
             
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
    
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        margin: EdgeInsets.only(left: isSender? 80: 0,right: isSender? 0:80,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(data.media != null && (data.media?.type??0) == MediaType.image)
            AppCacheImage(imageUrl: data.media?.url??"",onTap: () {
              Go.to(context, ImagePreview(url: data.media?.url??""));
            },),
            if(data.media != null && (data.media?.type??0) == MediaType.video)
            Stack(
              alignment: Alignment.center,
              children: [
                AppCacheImage(imageUrl: data.media?.thumbnail??"",onTap: () {
                  Go.to(context, TKVideoPlayer(media: data));
                },),
                GestureDetector(
                  onTap: () {
                  Go.to(context, TKVideoPlayer(media: data));
                  },
                  child: const Icon(Icons.play_circle_outline_rounded,color: Colors.white,size: 40,))
              ],
            ),
           
            Text(data.message),
          ],
        )),
        Text(DateFormat("hh:mm").format(data.messageTime)),
        const SizedBox(height: 7,)
    ],
                      );
  }
}