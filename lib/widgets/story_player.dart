import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/story_model.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:story_view/story_view.dart';
import 'package:video_player/video_player.dart';
import '../src/app_colors.dart';
import '../utils/media_type.dart';
import 'app_cache_image.dart';

class CustomStoryView extends StatefulWidget {
  final List<StoryModel> mediaList;
  const CustomStoryView({super.key, required this.mediaList});

  @override
  State<CustomStoryView> createState() => _CustomStoryViewState();
}

class _CustomStoryViewState extends State<CustomStoryView> {
  StoryController storyController = StoryController();
  List<StoryItem> storyItem = [];
  Future<Duration> getDurations(StoryModel media) async {
    final file = await getCacheFile(media.url, media.id);
    VideoPlayerController videoPlayerController =
        VideoPlayerController.file(file);
    await videoPlayerController.initialize();
    return videoPlayerController.value.duration;
  }

  Future<File> getCacheFile(String url, String id) async {
    File? file;
    try {
      var olderFile = await DefaultCacheManager().getFileFromMemory(id);
      if (await olderFile?.file.exists() ?? false) return olderFile!.file;
      var oldFile = await DefaultCacheManager().getFileFromCache(id);
      if (await oldFile?.file.exists() ?? false) return oldFile!.file;
      file = await DefaultCacheManager().getSingleFile(url, key: id);
    } catch (e) {
      showOkAlertDialog(
          context: context, message: e.toString(), title: "Error");
    }

    return file!;
  }

  bool isLoading = false;

  void getStoryMedia() async {
    Duration duration = Duration.zero;
    setState(() {
      isLoading = true;
    });
    for (final e in widget.mediaList) {
      if (e.type == MediaType.video) {
        duration = await getDurations(e);
      }
      setState(() {
        storyItem.add(e.type == MediaType.video
            ? StoryItem.pageVideo(e.url,
                controller: storyController, duration: duration)
            : StoryItem.pageImage(
                url: e.url,
                controller: storyController,
                duration: const Duration(seconds: 10)));
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getStoryMedia();
    super.initState();
  }

  @override
  void dispose() async {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.redColor,
        foregroundColor: AppColors.whiteColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.whiteColor, width: 1)),
              child: AppCacheImage(
                imageUrl: widget.mediaList[0].userImage,
                height: 50,
                width: 50,
                round: 50,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mediaList[0].userName,
                  style:
                      AppTextStyle.font16.copyWith(color: AppColors.whiteColor),
                ),
                // Text(
                //   DateFormat("").format(date),
                //   style:
                //       AppTextstyle.font14.copyWith(color: AppColors.whiteColor),
                // ),
              ],
            )
          ],
        ),
      ),
      body: storyItem.isNotEmpty && !isLoading
          ? StoryView(
              onVerticalSwipeComplete: (p0) {},
              onStoryShow: (storyItem, index) {},
              storyItems: storyItem,
              controller: storyController,
              inline: true,
              onComplete: () {
                Go.back(context);
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
            )
          : isLoading
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.redColor))
              : Center(
                  child: Flexible(
                    child: Text(
                      "There is no story for {widget.placesData.title}",
                      style: AppTextStyle.font16,
                    ),
                  ),
                ),
    );
  }
}
