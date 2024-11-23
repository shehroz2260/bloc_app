import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/edit_profile.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/galler_view.dart';
import 'package:chat_with_bloc/view/main_view/profile_tab/setting_view.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:chat_with_bloc/widgets/image_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/user_model.dart';
import '../../../services/stripe_payment.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          elevation: 4,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: AppColors.borderGreyColor,
            ),
            height: MediaQuery.of(context).size.height * 0.63,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: BlocBuilder<UserBaseBloc, UserBaseState>(
                builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.redColor),
                      padding: const EdgeInsets.all(4),
                      child: AppCacheImage(
                          imageUrl: state.userData.profileImage,
                          height: 180.h,
                          width: 180.h,
                          onTap: () {
                            Go.to(
                                context,
                                ImageView(
                                    imageUrl: state.userData.profileImage));
                          },
                          round: 180.r)),
                  const AppHeight(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${state.userData.firstName}, ",
                          style: AppTextStyle.font25
                              .copyWith(color: AppColors.blackColor)),
                      Text(state.userData.age.toString(),
                          style: AppTextStyle.font30
                              .copyWith(color: AppColors.blackColor)),
                    ],
                  ),
                  AppHeight(height: 25.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 40.h),
                        child: ProfileWidget(
                          title: AppLocalizations.of(context)!.settings,
                          icon: AppAssets.settingICon,
                          onTap: () async {
                            Go.to(context, const SettingView());
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: ProfileWidget(
                          title: AppLocalizations.of(context)!.editProfile,
                          icon: AppAssets.pencilICon,
                          onTap: () {
                            Go.to(context, const EditProfile());
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 40.h),
                        child: ProfileWidget(
                          title: AppLocalizations.of(context)!.gallery,
                          icon: '',
                          onTap: () {
                            Go.to(context, const GallerView());
                          },
                        ),
                      ),
                    ],
                  ),
                  AppHeight(height: 30.h)
                ],
              );
            }),
          ),
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.appIcon,
                  height: 50,
                ),
                const AppWidth(width: 10),
                Text(
                  "Fiendzy",
                  style:
                      AppTextStyle.font30.copyWith(color: AppColors.redColor),
                )
              ],
            ),
            const AppHeight(height: 10),
            const Text(
                "Upgrade to the Friendzy premium to access all features"),
            const AppHeight(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomNewButton(
                  btnName: "Go with premium",
                  onTap: () async {
                    try {
                      LoadingDialog.showProgress(context);
                      var userBloc = context.read<UserBaseBloc>();
                      var myModel = userBloc.state.userData;
                      var cusId = myModel.cusId;
                      if (cusId.isEmpty) {
                        var email = myModel.email;
                        var uid = myModel.uid;
                        final stripeCustomer = StripCustomer(uid, email);
                        var customer = await stripeCustomer.getCustomer();
                        cusId = customer['id'];
                        myModel = myModel.copyWith(cusId: cusId);
                        userBloc.add(UpdateUserEvent(userModel: myModel));
                        await FirebaseFirestore.instance
                            .collection(UserModel.tableName)
                            .doc(myModel.uid)
                            .set(myModel.toMap(), SetOptions(merge: true));
                      }
                      var card = StripCard(cusId);
                      var map = await card.getMyCards();
                      LoadingDialog.hideProgress(context);
                      if ((map['data'] as List).isEmpty) {
                        var stripePayment = StripSetupIntent(cusId, context);
                        await stripePayment.makeDefaultCard();
                      } else {
                        var cardList = map["data"] as List;
                        //  const customer = await Stripe.customer
                        var defaultPaymentMethodId =
                            cardList[0]["card"]["id"] ?? '';

                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    )),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ...List.generate(cardList.length + 1, (i) {
                                      if (cardList.length == i) {
                                        return GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () async {
                                            var userBloc =
                                                context.read<UserBaseBloc>();
                                            var myModel =
                                                userBloc.state.userData;
                                            var cusId = myModel.cusId;
                                            if (cusId.isEmpty) {
                                              var email = myModel.email;
                                              var uid = myModel.uid;
                                              final stripeCustomer =
                                                  StripCustomer(uid, email);
                                              var customer =
                                                  await stripeCustomer
                                                      .getCustomer();
                                              cusId = customer['id'];
                                              myModel = myModel.copyWith(
                                                  cusId: cusId);
                                              userBloc.add(UpdateUserEvent(
                                                  userModel: myModel));
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      UserModel.tableName)
                                                  .doc(myModel.uid)
                                                  .set(myModel.toMap(),
                                                      SetOptions(merge: true));
                                            }
                                            var stripePayment =
                                                StripSetupIntent(
                                                    cusId, context);
                                            await stripePayment
                                                .makeDefaultCard();
                                            Go.back(context);
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                    color: AppColors
                                                        .borderGreyColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: const Icon(Icons.add),
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                "Add card",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                          defaultPaymentMethodId =
                                              cardList[i]["card"]["id"];
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: AppColors
                                                      .borderGreyColor)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  '${cardList[i]["card"]['brand']} **** **** **** ${cardList[i]["card"]['last4']}',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'inter',
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          AppColors.redColor),
                                                  borderRadius:
                                                      BorderRadius.circular(49),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: cardList[i]["card"]
                                                                  ['id'] ==
                                                              defaultPaymentMethodId
                                                          ? AppColors.redColor
                                                          : Colors.transparent,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            });
                        // log("^^^^^^^^^^^^^^^^^^^^^${list.length}");
                        // log("^^^^^^^^^^^^^^^^^^^^^$list");
                      }
                    } on FirebaseException catch (e) {
                      LoadingDialog.hideProgress(context);
                      showOkAlertDialog(
                          context: context, message: e.message, title: "Error");
                    } catch (e) {
                      LoadingDialog.hideProgress(context);
                      showOkAlertDialog(
                          context: context,
                          message: e.toString(),
                          title: "Error");
                    }
                  }),
            )
          ],
        ))
      ],
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final void Function() onTap;
  final String icon;
  final String title;
  const ProfileWidget(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.redColor,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 4)
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: icon.isEmpty
                ? Icon(Icons.camera_alt, color: AppColors.whiteColor, size: 32)
                : SvgPicture.asset(
                    icon,
                    colorFilter:
                        ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
                  ),
          ),
          const AppHeight(height: 7),
          Text(title,
              style: AppTextStyle.font16.copyWith(color: AppColors.blackColor))
        ],
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
