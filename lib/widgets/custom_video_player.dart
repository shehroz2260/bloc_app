// ignore_for_file: deprecated_member_use
import 'dart:developer';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../model/char_model.dart';
import '../src/app_colors.dart';
import 'app_cache_image.dart';

class TKVideoPlayer extends StatefulWidget {
  final ChatModel media;

  const TKVideoPlayer({
    super.key,
    required this.media,
  });

  @override
  State<TKVideoPlayer> createState() => _TKVideoPlayerState();
}

class _TKVideoPlayerState extends State<TKVideoPlayer> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    initNetworkPlayer();
  }

  Future<void> initNetworkPlayer() async {
    _controller = VideoPlayerController.network(
      widget.media.media?.url??"",
    )..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: true,
          allowFullScreen: false,
          allowMuting: false,
          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          showControls: true,
          errorBuilder: (context, errorMessage) {
            return const Center(
              child: Text(
                'Error while playing video.',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        );
        isPlaying = true;
        log('playing the video');

        setState(() {});
      });
    // await _controller.initialize();
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
      _chewieController.dispose();
    } catch (error) {
      //
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        elevation: 0,
        iconTheme:  IconThemeData(color: AppColors.whiteColor),
      ),
      body: SafeArea(
        top: false,
        child: _controller.value.isInitialized
            ? Theme(
                data: ThemeData(
                    progressIndicatorTheme:  ProgressIndicatorThemeData(
                        color: AppColors.whiteColor)),
                child: Chewie(controller: _chewieController))
            : SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AppCacheImage(
                      height: MediaQuery.of(context).size.height,
                      imageUrl: widget.media.media?.thumbnail ?? "",
                      width: double.infinity,
                      round: 0,
                    ),
                     CircularProgressIndicator(
                      color: AppColors.whiteColor,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
