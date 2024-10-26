import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/view_model/filter_bloc.dart/filter_bloc.dart';
import 'package:chat_with_bloc/view_model/filter_bloc.dart/filter_state.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_bloc.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_event.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_state.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../../src/app_text_style.dart';
import '../../../src/width_hieght.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../view_model/filter_bloc.dart/filter_event.dart';
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
    UserBaseBloc ancestorContext = UserBaseBloc();
  @override
  void didChangeDependencies() {
   ancestorContext = MyInheritedWidget(bloc: context.read<UserBaseBloc>(),child: const SizedBox()).bloc;
    super.didChangeDependencies();
  }

  void _openFilterDialog()async{
    showModalBottomSheet(
      isScrollControlled: true,
      context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height * 0.8,
         decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
         ),
         child:  Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeight(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Clear",style: AppTextStyle.font20.copyWith(color: AppColors.whiteColor,fontWeight: FontWeight.bold)),
                  Text("Filter",style: AppTextStyle.font20.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold)),
                  Text("Clear",style: AppTextStyle.font20.copyWith(color: AppColors.redColor,fontWeight: FontWeight.bold))
                ],
              ),
              const AppHeight(height: 30),
              Text("Interested in",style: AppTextStyle.font20.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold)),
             const AppHeight(height: 15),
             const InterestedInWidget(),
             const AppHeight(height: 30),
             BlocBuilder<FilterBloc, FilterState>(
               builder: (context,state) {
                 return SfRangeSliderTheme(
                                data: SfRangeSliderThemeData(
                                    overlayColor: Colors.transparent,
                                    activeTrackHeight: 2,
                                    inactiveTrackHeight: 2,
                                    inactiveTrackColor:
                                        AppColors.redColor.withOpacity(.5),
                                    activeTrackColor: AppColors.redColor,
                                    thumbRadius: 16,
                                    thumbStrokeWidth: 1.5,
                                    thumbStrokeColor: AppColors.redColor,
                                    thumbColor: AppColors.whiteColor),
                                child: SfRangeSlider(
                                  values: SfRangeValues(state.minAge.toDouble(),
                                      state.maxAge.toDouble()),
                                  onChanged: (value)=> context.read<FilterBloc>().add(ONChangedAges(onChanged: value)),
                                  max: 100,
                                  min: 18,
                                  startThumbIcon: Center(
                                      child: Text(
                                    state.minAge.toInt().toString(),
                                    style:  TextStyle(
                                        fontSize: 14,
                                        color: AppColors.redColor),
                                  )),
                                  endThumbIcon: Center(
                                    child: Text(
                                     state.maxAge == 100? "100+": state.maxAge.toInt().toString(),
                                      style:  TextStyle(
                                          fontSize:state.maxAge == 100?11: 14,
                                          color: AppColors.redColor),
                                    ),
                                  ),
                                ),
                              );
               }
             ),
             const AppHeight(height: 30),
             CustomNewButton(btnName: "Apply",onTap: () {
                context.read<FilterBloc>().add(OnAppLyFilter(context: context,userBloc: ancestorContext));
               
             })
            ],
           ),
         ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(children: [
          const AppHeight(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 50),
                Text(AppStrings.discover, style: AppTextStyle.font25.copyWith(color: AppColors.blackColor)),
                GestureDetector(
                  onTap: () {
                    _openFilterDialog();
                  },
                  child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.borderGreyColor,
                    ),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(AppAssets.filterIcon),
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
            child: Text("There is no users",style: AppTextStyle.font16.copyWith(color: AppColors.blackColor)),
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
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                ),
                                TextSpan(
                                  text: '${user.age}',
                                  style:  TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blackColor,
                                      fontSize: 24,),
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
        ]);
      },
    );
  }
}

class InterestedInWidget extends StatefulWidget {
  const InterestedInWidget({
    super.key,
  });

  @override
  State<InterestedInWidget> createState() => _InterestedInWidgetState();
}

class _InterestedInWidgetState extends State<InterestedInWidget> {
  @override
  void initState() {
   context.read<FilterBloc>().add(ONInitEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc,FilterState>(
      builder: (context,state) {
        return Row(
         children: [
           Expanded(
             child: GestureDetector(
              onTap: () {
                context.read<FilterBloc>().add(OnChangedGender(gender: 1));
              },
               child: Container(
                 decoration: BoxDecoration(
                  color: state.gender == 1? AppColors.redColor : null,
                   borderRadius: const BorderRadius.only(
                     topLeft: Radius.circular(25),
                     bottomLeft: Radius.circular(25)
                   ),
                   border: Border(
                     bottom: BorderSide(
                       color: AppColors.borderGreyColor
                     ),
                     top: BorderSide(
                       color: AppColors.borderGreyColor
                     ),
                     left: BorderSide(
                       color: AppColors.borderGreyColor
                     ),
                   )
                 ),
                 padding: const EdgeInsets.symmetric(vertical: 18),
                 alignment: Alignment.center,
                 child: Text("Men",style: AppTextStyle.font16.copyWith(color:state.gender == 1? AppColors.whiteColor: AppColors.redColor)),
               ),
             ),
           ),
            Expanded(
             child: GestureDetector(
              onTap: () {
                 context.read<FilterBloc>().add(OnChangedGender(gender: 2));
              },
               child: Container(
                 decoration: BoxDecoration(
                  color: state.gender == 2? AppColors.redColor : null,
                   border: Border(
                     bottom: BorderSide(
                       color: AppColors.borderGreyColor
                     ),
                     top: BorderSide(
                       color: AppColors.borderGreyColor
                     ),
                    
                   )
                 ),
                 padding: const EdgeInsets.symmetric(vertical: 18),
                 child:  Container(
                 alignment: Alignment.center,
                   width: double.infinity,
                   decoration: BoxDecoration(
                     border: Border(
                       left: BorderSide(
                         color: AppColors.borderGreyColor
                       ),
                       right:  BorderSide(
                         color: AppColors.borderGreyColor
                       )
                     )
                   ),
                   child: Text("Women",style: AppTextStyle.font16.copyWith(color:state.gender == 2? AppColors.whiteColor: AppColors.redColor))),
               ),
             ),
           ),
            Expanded(
             child: GestureDetector(
               onTap: () {
                 context.read<FilterBloc>().add(OnChangedGender(gender: 0));
              },
               child: Container(
                 decoration: BoxDecoration(
                  color: state.gender == 0? AppColors.redColor : null,
                   borderRadius: const BorderRadius.only(
                     topRight: Radius.circular(25),
                     bottomRight: Radius.circular(25)
                   ),
                   border: Border(
                     bottom: BorderSide(
                       color: AppColors.borderGreyColor
                     ),
                     top: BorderSide(
                       color: AppColors.borderGreyColor
                     ),
                     right: BorderSide(
                       color: AppColors.borderGreyColor
                     ),
                   )
                 ),
                 padding: const EdgeInsets.symmetric(vertical: 18),
                 alignment: Alignment.center,
                 child: Text("Both",style: AppTextStyle.font16.copyWith(color: state.gender == 0? AppColors.whiteColor: AppColors.redColor)),
               ),
             ),
           )
         ],
                    );
      }
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
          border: Border.all(color: AppColors.redColor,width: 2),
          shape: BoxShape.circle
        ),
        child: svgICon == null? Icon(icon,color: AppColors.redColor): SvgPicture.asset(svgICon??""),
      ),
    );
  }
}



class MyInheritedWidget extends InheritedWidget {
  final UserBaseBloc bloc;

  const MyInheritedWidget({
    super.key,
    required this.bloc,
    required super.child,
  });

  // Access the BLoC from the widget tree.
  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant MyInheritedWidget oldWidget) {
    // Notify when the BLoC changes (not needed here because BLoC is the same).
    return false;
  }
}