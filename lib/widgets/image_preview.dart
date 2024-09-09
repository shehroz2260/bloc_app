import 'package:chat_with_bloc/src/go_file.dart';
import 'package:flutter/material.dart';
import 'app_cache_image.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox(width: double.infinity, height: double.infinity),
        Dismissible(
          direction: DismissDirection.vertical,
          key: const Key('key'),
          onDismissed: (_) => Go.back(context),
          child: InteractiveViewer(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: AppCacheImage(
                round: 0,
                imageUrl: url,
                width: double.infinity,
                height: null,
                boxFit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 10,
          child: SafeArea(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Card(
                  color: Colors.white,
                  shape: CircleBorder(),
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Icon(Icons.arrow_back_ios,
                            color: Colors.black, size: 18),
                      ))),
            ),
          ),
        )
      ],
    );
  }
}
