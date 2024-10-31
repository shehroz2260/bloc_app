import 'package:chat_with_bloc/view_model/gallery_bloc/gallery_bloc.dart';
import 'package:chat_with_bloc/view_model/gallery_bloc/gallery_event.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_state.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../src/app_colors.dart';
import '../../../widgets/app_cache_image.dart';

class GallerView extends StatelessWidget {
  const GallerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 26, top: 20, right: 16),
        child: SafeArea(
          child: BlocBuilder<UserBaseBloc, UserBaseState>(
            
              builder: (context, state) {
                return Column(
                  children: [
                    Row(
                      children: [
                       const CustomBackButton(),
                        const SizedBox(width: 20),
                         Text(
                          'Gallery',
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 38),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (state.userData.galleryImages.isNotEmpty)
                      Wrap(
                        children: List.generate(
                            state.userData.galleryImages.length,
                            (index) => Stack(
                                  alignment: Alignment.topLeft,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2.5,
                                      margin: const EdgeInsets.only(
                                          right: 10, bottom: 10),
                                      height: 150,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        child: AppCacheImage(
                                          imageUrl: state.userData.galleryImages[index],
                                          height: MediaQuery.of(context).size.height,
                                          width: MediaQuery.of(context).size.width,
                                          boxFit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => context.read<GalleryBloc>().add(ClearImage(index: index, context: context)),
                                      child:  Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.cancel,
                                          color: AppColors.borderGreyColor,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                      ),
                    const Spacer(),
                    if (state.userData.galleryImages.length  <
                        6)
                      CustomNewButton(
                        btnName: "Add image",
                        onTap: ()=> context.read<GalleryBloc>().add(SelectImage(context: context)),
                      ),
                    const SizedBox(height: 30)
                  ],
                );
              }),
        ),
      ),
    );
  }
}