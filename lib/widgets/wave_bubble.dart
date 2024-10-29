import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/utils/app_funcs.dart';
import 'package:flutter/material.dart';

class WaveBubble extends StatefulWidget {
  final String path;
  final String id;
  final bool isFromNetwork;
  final bool isSender;
  const WaveBubble(
      {super.key,
      required this.path,
      this.isFromNetwork = false,
      required this.id, required this.isSender});

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  late final PlayerController playerController1;

  @override
  void initState() {
    _preparePlayer();
    playerController1 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() async {
    playerController1.dispose();
    super.dispose();
  }

  void _preparePlayer() async {
    if (widget.isFromNetwork) {
      final file = await AppFuncs.getCacheFile(widget.path, widget.id,context);
      bool exist = await file!.exists();
      if (exist) {
        playerController1.preparePlayer(
          path: file.path,
        );
      }
    }
    if (!widget.isFromNetwork) {
      final file = File(widget.path);
      bool exist = await file.exists();
      if (exist) {
        playerController1.preparePlayer(
          path: file.path,
        );
      }
    }
    playerController1.onCompletion.listen((event) {
      setState(() {});
    });
    setState(() {});
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      height: 52,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: !widget.isSender? AppColors.redColor.withOpacity(0.15): AppColors.borderGreyColor,
          border: Border.all(
            width: 1,
            color: Colors.white.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(14))),
      child: Row(
        children: [
          if (!playerController1.playerState.isStopped)
            GestureDetector(
              onTap: () async {
                playerController1.playerState.isPlaying
                    ? await playerController1.pausePlayer()
                    : await playerController1.startPlayer(
                        finishMode: FinishMode.pause);
              },
              child: Container(
                height: 24,
                width: 24,
                margin: const EdgeInsets.only(left: 20, right: 8.5),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.pink),
                child: playerController1.playerState.isPlaying
                    ? const Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 15,
                      ): const Icon(Icons.play_arrow_sharp,color: Colors.white,size: 15)
                    // : SvgPicture.asset(
                    //     AppAssets.playArrowIcon,
                    //     colorFilter: ColorFilter.mode(
                    //         AppColors.secondaryColor, BlendMode.srcIn),
                    //   ),
              ),
            ),
          Expanded(
            child: AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width /3, 50),
              playerController: playerController1,
              waveformType: WaveformType.long,
              playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: Colors.white,
                liveWaveColor: Colors.pink.shade400,
                spacing: 6,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 8.5),
            child: Text(
              formatDuration(Duration(milliseconds: playerController1.maxDuration)),
              style: const TextStyle(color: Colors.white),
              // style: AppTextStyle.size12.copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}