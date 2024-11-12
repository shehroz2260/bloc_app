import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/view_model/gallery_bloc/gallery_bloc.dart';
import 'package:chat_with_bloc/view_model/gallery_bloc/gallery_event.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_state.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../src/app_colors.dart';
import '../../../widgets/app_cache_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(),
                    Text(
                      AppLocalizations.of(context)!.gallery,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                          fontSize: 30),
                    ),
                    const SizedBox(width: 60),
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
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  margin: const EdgeInsets.only(
                                      right: 10, bottom: 10),
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    child: AppCacheImage(
                                      imageUrl:
                                          state.userData.galleryImages[index],
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    var res = await showOkCancelAlertDialog(
                                        context: context,
                                        message: AppLocalizations.of(context)!
                                            .doYouReallyWantToDeleteImage,
                                        title: AppLocalizations.of(context)!
                                            .areYouSure,
                                        okLabel:
                                            AppLocalizations.of(context)!.yes,
                                        cancelLabel:
                                            AppLocalizations.of(context)!.no);
                                    if (res == OkCancelResult.cancel) return;
                                    context.read<GalleryBloc>().add(ClearImage(
                                        index: index, context: context));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: AppColors.redColor),
                                        color: AppColors.whiteColor
                                            .withOpacity(0.6)),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            )),
                  ),
                const Spacer(),
                if (state.userData.galleryImages.length < 6)
                  CustomNewButton(
                    btnName: AppLocalizations.of(context)!.addImage,
                    onTap: () => context
                        .read<GalleryBloc>()
                        .add(SelectImage(context: context)),
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
