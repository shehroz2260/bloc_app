import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String imageUrl;
  const ImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          InteractiveViewer(
            child: AppCacheImage(
              imageUrl: imageUrl,
              height: double.infinity,
              round: 0,
              boxFit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
          const Positioned(top: 60, left: 20, child: CustomBackButton()),
        ],
      ),
    );
  }
}
