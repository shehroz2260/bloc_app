import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:chat_with_bloc/widgets/see_more_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../account_creation_view/preference_view.dart';
import 'see_all_gallery_images.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfileView extends StatelessWidget {
  final UserModel user;
  final bool isCUser;
  const UserProfileView({super.key, required this.user, this.isCUser = false});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 350,
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            AppCacheImage(
                              imageUrl: user.profileImage,
                              width: double.infinity,
                              height: 350,
                              round: 0,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 30,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: theme.bgColor,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppHeight(height: 60),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text("${user.firstName}, ",
                                          style: AppTextStyle.font25.copyWith(
                                              color: theme.textColor,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Text(user.age.toString(),
                                        style: AppTextStyle.font25.copyWith(
                                            color: theme.textColor,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Text(
                                  " ${user.bio}",
                                  style: TextStyle(color: theme.textColor),
                                )
                              ],
                            ),
                          ),
                          const AppWidth(width: 10),
                          if (!isCUser)
                            GestureDetector(
                              onTap: () async {
                                var res = await showOkCancelAlertDialog(
                                    context: context,
                                    title:
                                        AppLocalizations.of(context)!.direction,
                                    okLabel: AppLocalizations.of(context)!.yes,
                                    cancelLabel:
                                        AppLocalizations.of(context)!.notNow,
                                    message: AppLocalizations.of(context)!
                                        .doYouWantToGetDirection);
                                if (res == OkCancelResult.cancel) return;

                                _getDirection(user.lat, user.lng);
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.borderGreyColor),
                                    borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(AppAssets.sendIcon),
                              ),
                            )
                        ],
                      ),
                      if (user.isShowLocation || isCUser)
                        const AppHeight(height: 30),
                      if (user.isShowLocation || isCUser)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.location,
                                    style: AppTextStyle.font20.copyWith(
                                        color: theme.textColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    user.location,
                                    style: AppTextStyle.font16
                                        .copyWith(color: theme.textColor),
                                  )
                                ],
                              ),
                            ),
                            const AppWidth(width: 5),
                            if (!isCUser)
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.redColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.locationICon),
                                    const AppWidth(width: 5),
                                    Text(
                                      "${user.distance(context, null)} km",
                                      style: AppTextStyle.font16.copyWith(
                                          color: AppColors.redColor,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      const AppHeight(height: 30),
                      Text(
                        AppLocalizations.of(context)!.about,
                        style: AppTextStyle.font20.copyWith(
                            color: theme.textColor,
                            fontWeight: FontWeight.bold),
                      ),
                      TextWithSeeMore(text: user.about),
                      const AppHeight(height: 30),
                      Text(
                        AppLocalizations.of(context)!.interests,
                        style: AppTextStyle.font20.copyWith(
                            color: theme.textColor,
                            fontWeight: FontWeight.bold),
                      ),
                      const AppHeight(height: 10),
                      GridView.builder(
                          shrinkWrap: true,
                          hitTestBehavior: HitTestBehavior.opaque,
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 3.4),
                          itemCount: user.myInstrest.length,
                          itemBuilder: (context, index) {
                            final interest = user.myInstrest[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                  color: AppColors.redColor,
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: AppColors.redColor)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(interestList[interest].icon,
                                      colorFilter: ColorFilter.mode(
                                          AppColors.whiteColor,
                                          BlendMode.srcIn)),
                                  const AppWidth(width: 10),
                                  Text(interestList[interest].name,
                                      style: AppTextStyle.font16.copyWith(
                                          fontSize: 14,
                                          color: AppColors.whiteColor))
                                ],
                              ),
                            );
                          }),
                      const AppHeight(height: 30),
                      GestureDetector(
                        onTap: () {
                          Go.to(context, SeeAllGalleryImages(user: user));
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.gallery,
                                  style: AppTextStyle.font20.copyWith(
                                      color: theme.textColor,
                                      fontWeight: FontWeight.bold)),
                              Text(AppLocalizations.of(context)!.seeAll,
                                  style: AppTextStyle.font16.copyWith(
                                      color: AppColors.redColor,
                                      fontWeight: FontWeight.bold))
                            ]),
                      ),
                      const AppHeight(height: 10),
                      if (user.galleryImages.isNotEmpty)
                        AppCacheImage(
                            imageUrl: user.galleryImages[0],
                            height: 200,
                            width: double.infinity),
                      const AppHeight(height: 10),
                      if (user.galleryImages.isNotEmpty &&
                          user.galleryImages.length > 1)
                        Row(
                          children: [
                            Expanded(
                                child: AppCacheImage(
                                    imageUrl: user.galleryImages[1],
                                    height: 200)),
                            if (user.galleryImages.length > 2)
                              const AppWidth(width: 10),
                            if (user.galleryImages.length > 2)
                              Expanded(
                                  child: AppCacheImage(
                                      imageUrl: user.galleryImages[2],
                                      height: 200)),
                          ],
                        ),
                      const AppHeight(height: 20)
                    ],
                  ),
                )
              ],
            ),
          ),
          const Positioned(
              top: 70, left: 30, child: CustomBackButton(isUSerPRofile: true)),
        ],
      ),
    );
  }

  void _getDirection(double lat, double lng) async {
    await launchUrlString("${AppConstant.googleMapsUrl}$lat,$lng");
  }
}
