import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/view/main_view/home_tab/filter_view.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_bloc.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_event.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_state.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../src/app_text_style.dart';
import '../../../src/width_hieght.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/app_cache_image.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    context.read<HomeBloc>().add(ONINITEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(children: [
          const AppHeight(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 35),
                Text("Home", style: AppTextStyle.font25),
                GestureDetector(
                  onTap: () {
                    Go.to(context, const FilterView());
                  },
                  child: SizedBox(
                    width: 35,
                    child: Icon(
                      Icons.filter_alt_outlined,
                      color: AppColors.whiteColor,
                      size: 35,
                    ),
                  ),
                )
              ],
            ),
          ),
          const AppHeight(height: 20),
               if(state.isLoading )
          Expanded(child: Center(
            child: CircularProgressIndicator(color: AppColors.blueColor),
          )),
          if(!state.isLoading && state.userList.isEmpty)
          Expanded(child: Center(
            child: Text("There is no users",style: AppTextStyle.font16),
          )),
          if(!state.isLoading && state.userList.isNotEmpty)
          Expanded(
            child: Stack(
            children: [
              PageView.builder(
                  controller: PageController(),
                  scrollDirection: Axis.vertical,
                  itemCount: state.userList.length,
                  itemBuilder: (context, index) {
                    var user = state.userList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AnimatedSwitcher(
                        transitionBuilder: (child, animation) {
                          return SlideTransition(
                              position: Tween<Offset>(
                                      begin: const Offset(0, 1),
                                      end: const Offset(0, 0))
                                  .animate(animation),
                              child: child);
                        },
                        duration: const Duration(milliseconds: 200),
                        child: Dismissible(
                          direction: DismissDirection.none,
                          movementDuration: const Duration(milliseconds: 1),
                          resizeDuration: const Duration(milliseconds: 1),
                         
                          key: ValueKey(state.userList[index]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                   alignment: Alignment.bottomRight,
                                  children: [
                                    AppCacheImage(
                                      onTap: () {
                                      },
                                      imageUrl: user.profileImage,
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 0.75,
                                      round: 25,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          WidgetForLikeorDislike(
                                                                               icon: Icons.info,
                                                                               onTap: () {
                                                                                // Get.to(()=> InfoScreen(userModel: controller.users[index]));
                                                                               }
                                                                              ), 
                                         const SizedBox(height: 15),
                                         WidgetForLikeorDislike(
                                          icon: Icons.favorite,
                                          onTap: (){
                                            context.read<HomeBloc>().add(LikeUser(likee: user, context: context, liker: context.read<UserBaseBloc>().state.userData));
                                            //  controller.likeUser(user);
                                          }
                                         ),
                                         const SizedBox(height: 15),
                                     WidgetForLikeorDislike(
                                          icon: Icons.remove,
                                          onTap: (){ 
                                            context.read<HomeBloc>().add(DisLikeUser(likee: user, liker: context.read<UserBaseBloc>().state.userData));

                                            // controller.disLikeUser(user);
                                          }
                                         ),
                                         const SizedBox(height: 15),
                                       WidgetForLikeorDislike(
                                          icon: Icons.report, 
                                          onTap: (){
                                            //  controller.reportUser(controller.users[index]);
                                          }
                                          ),
                                         const SizedBox(height: 15),
            
                                        ],
                                      ),
                                    ),
                                    
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 13),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: "${user.firstName},",
                                  style:  TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 20,
                                    ),
                                ),
                                TextSpan(
                                  text: '${user.age}',
                                  style:  TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 20,),
                                ),
                              ])),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ],
                    ),
          ),






































          //  PageView.builder(
          //       controller: PageController(),
          //       scrollDirection: Axis.vertical,
          //       itemCount: state.userList.length,
          //       itemBuilder: (context, index) {
          //         var user = state.userList[index];
          //         return Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 20),
          //           child: AnimatedSwitcher(
          //             transitionBuilder: (child, animation) {
          //               return SlideTransition(
          //                   position: Tween<Offset>(
          //                           begin: const Offset(0, 1),
          //                           end: const Offset(0, 0))
          //                       .animate(animation),
          //                   child: child);
          //             },
          //             duration: const Duration(milliseconds: 200),
          //             child: Dismissible(
          //               movementDuration: const Duration(milliseconds: 1),
          //               resizeDuration: const Duration(milliseconds: 1),
          //               onUpdate: (details) {
          //                 if (details.direction == DismissDirection.startToEnd &&
          //                     details.progress >= 0.4) {
                           
          //                 }
          //                 if (details.direction == DismissDirection.endToStart &&
          //                     details.progress >= 0.4) {
                          
          //                 }
          //               },
          //               onDismissed: (direction) async {
          //                 context.read<HomeBloc>().add(RemoveUserFromList(userModel: user));
          //                 if (direction == DismissDirection.startToEnd) {
          //                   // controller.likeUser(user);
          //                 }
          //                 if (direction == DismissDirection.endToStart) {
          //                   // controller.disLikeUser(user);
          //                 }
          //               },
          //               key: ValueKey(state.userList[index]),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Expanded(
          //                     child: AppCacheImage(
          //                       onTap: () {
          //                         // Go.to(context,
          //                         //    PreviewScreen(
          //                         //           users: [
          //                         //             controller.users[index].imageUrl ??
          //                         //                 "",
          //                         //             ...(controller.users[index]
          //                         //                     .galleryImages ??
          //                         //                 [])
          //                         //           ],
          //                         //         ),
          //                         //     arguments: {"index": 0});
          //                       },
          //                       imageUrl: user.profileImage,
          //                       width: double.infinity,
          //                       height: MediaQuery.of(context).size.height * 0.75,
          //                       round: 25,
          //                     ),
          //                   ),
          //                   const SizedBox(height: 13),
          //                   RichText(
          //                       text: TextSpan(children: [
          //                     TextSpan(
          //                       text: "${user.name }, ",
          //                       style:  AppTextStyle.font16,
          //                     ),
          //                     TextSpan(
          //                       text: '${user.age}',
          //                       style: AppTextStyle.font16,
          //                     ),
          //                   ])),
          //                   const SizedBox(height: 8),
          //                   // SingleChildScrollView(
          //                   //   scrollDirection: Axis.horizontal,
          //                   //   child: Row(
          //                   //     children: [
          //                   //       ...(user.selectedInterestList ?? []).map(
          //                   //         (e) => Row(children: [
          //                   //           Container(
          //                   //             padding: const EdgeInsets.symmetric(
          //                   //                 horizontal: 10, vertical: 6),
          //                   //             decoration: BoxDecoration(
          //                   //               color: AppColors.purple,
          //                   //               borderRadius: BorderRadius.circular(38),
          //                   //             ),
          //                   //             child: Text(
          //                   //               PreferencesScreenController()
          //                   //                       .interestList[int.parse(e)]
          //                   //                   ['trailing'],
          //                   //               style: const TextStyle(
          //                   //                   color: AppColors.white,
          //                   //                   fontSize: 12,
          //                   //                   fontFamily: AppFonts.interRegular),
          //                   //             ),
          //                   //           ),
          //                   //           const SizedBox(width: 7),
          //                   //         ]),
          //                   //       ),
          //                   //     ],
          //                   //   ),
          //                   // ),
          //                   const SizedBox(height: 15),
                           
          //                 ],
          //               ),
          //             ),
          //           ),
          //         );
          //       }),
        ]);
      },
    );
  }
}



class WidgetForLikeorDislike extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  final String? svgICon;
  const WidgetForLikeorDislike({
    super.key, required this.icon, required this.onTap, this.svgICon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
            height: 40,
            width: 40,
            // margin:  const EdgeInsets.only(right: 15,bottom: 15),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.blueColor,width: 2),
          shape: BoxShape.circle
        ),
        child: svgICon == null? Icon(icon,color: AppColors.blueColor): SvgPicture.asset(svgICon??""),
      ),
    );
  }
}
