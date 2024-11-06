import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import 'app_cache_image.dart';

class ShowUserOnMapWidget extends StatelessWidget {
  const ShowUserOnMapWidget({
    super.key,
    required this.userModel,
    this.onTap,
  });
  final UserModel userModel;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          height: 152,
          decoration: BoxDecoration(
            color: AppColors.blackColor.withOpacity(0.15),
            border: Border.all(color: const Color(0xFF31353C), width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              AppCacheImage(
                imageUrl: userModel.profileImage,
                height: 124,
                width: mediaQuery.width / 3.6,
                round: 6,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userModel.firstName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15,
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 3),
                      Expanded(
                        child: Text(userModel.location,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13, color: AppColors.whiteColor)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
