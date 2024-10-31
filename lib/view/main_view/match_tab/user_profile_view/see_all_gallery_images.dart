import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/app_cache_image.dart';

class SeeAllGalleryImages extends StatefulWidget {
  final UserModel user;
  const SeeAllGalleryImages({super.key, required this.user});

  @override
  State<SeeAllGalleryImages> createState() => _SeeAllGalleryImagesState();
}

class _SeeAllGalleryImagesState extends State<SeeAllGalleryImages> {
   PageController? pageController;
   int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeight(height: 70),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CustomBackButton(),
          ),
          const AppHeight(height: 20),
          Expanded(
            child: PageView.builder(
            controller: pageController,
            itemCount: widget.user.galleryImages.length,
            onPageChanged: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: AppCacheImage(
                    round: 0,
                    imageUrl: widget.user.galleryImages[index],
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height),
              );
            },
                    ),
          ),
         const AppHeight(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(
                bottom: 30
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.user.galleryImages.length, (index){
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Stack(
                        children: [
                          AppCacheImage(imageUrl: widget.user.galleryImages[index],height: 40,width: 40,round: 10),
                         Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:index == selectedIndex? Colors.transparent: Colors.white38
                          ),
                         )
                        ],
                      )),
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}