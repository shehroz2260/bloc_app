import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/view/main_view/chat_tab/chat_view.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_bloc.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_state.dart';
import 'package:chat_with_bloc/view_model/matches_bloc/matches_bloc.dart';
import 'package:chat_with_bloc/view_model/matches_bloc/matches_event.dart';
import 'package:chat_with_bloc/view_model/matches_bloc/matches_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../src/app_colors.dart';
import '../../../src/app_string.dart';
import '../../../src/app_text_style.dart';
import '../../../src/width_hieght.dart';

class MatchTab extends StatefulWidget {
  const MatchTab({super.key});

  @override
  State<MatchTab> createState() => _MatchTabState();
}

class _MatchTabState extends State<MatchTab> {
 
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<MatchesBloc, MatchesState>(
      builder: (context,state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const AppHeight(height: 60),
                Text (state.index == 0? "Likes": AppStrings.matches, style: AppTextStyle.font25.copyWith(color: AppColors.blackColor)),
                const AppHeight(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          context.read<MatchesBloc>().add(ChangeIndex(index: 0));

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: state.index ==0?AppColors.redColor: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color:state.index ==0? AppColors.redColor: AppColors.borderGreyColor
                            )
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child:  Text("Likes",style: TextStyle(
                            fontSize: 16,
                            color: state.index ==0? AppColors.whiteColor: AppColors.redColor
                          ),),
                        ),
                      ),
                    ),
                    const AppWidth(width: 20),
                     Expanded(
                      child: GestureDetector(
                        onTap: (){
                          context.read<MatchesBloc>().add(ChangeIndex(index: 1));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: state.index ==1?AppColors.redColor: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color:state.index ==1? AppColors.redColor: AppColors.borderGreyColor
                            )
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child:  Text(AppStrings.matches,style: TextStyle(
                            fontSize: 16,
                            color: state.index ==1? AppColors.whiteColor: AppColors.redColor
                          ),),
                        ),
                      ),
                    )
                  ],
                ),
                if(state.index == 0)
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 10,childAspectRatio: 0.7),itemCount: state.likesList.length, itemBuilder: (context,index){
                    return Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          AppCacheImage(imageUrl: state.likesList[index].profileImage,round: 15,width: double.infinity,height: double.infinity,boxFit: BoxFit.cover,),
                       if(state.likesList[index].matches.contains(FirebaseAuth.instance.currentUser?.uid??""))
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.whiteColor
                                ),
                                padding: const EdgeInsets.all(15),
                                child: SvgPicture.asset( AppAssets.heart,colorFilter: ColorFilter.mode(AppColors.redColor, BlendMode.srcIn),),
                              ),
                            ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                           
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text("${state.likesList[index].firstName}, ",style: AppTextStyle.font20.copyWith(fontWeight: FontWeight.bold)),
                                  Text(state.likesList[index].age.toString(),style: AppTextStyle.font25.copyWith(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              decoration:  BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                )
                              ),
                              child:  Row(
                                children: [
                                  Expanded(child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: SvgPicture.asset(AppAssets.cancelICon,height: double.infinity),
                                    ))),
                                if(!state.likesList[index].matches.contains(FirebaseAuth.instance.currentUser?.uid??""))

                                  Container(height: double.infinity,width: 2,color: AppColors.borderGreyColor),
                                if(!state.likesList[index].matches.contains(FirebaseAuth.instance.currentUser?.uid??""))
                                  Expanded(child: GestureDetector(
                                    onTap: () {
                                      
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: SvgPicture.asset(AppAssets.heart,height: double.infinity,colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        )
                        ],
                      ),
                    );
                  }),
                ),
                if(state.index == 1)
                Expanded(
                  child: BlocBuilder<InboxBloc, InboxState>(
                    builder: (context, inboxState) {
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 10,childAspectRatio: 0.7),itemCount: inboxState.threadList.length, itemBuilder: (context,index){
                        return Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              AppCacheImage(imageUrl: inboxState.threadList[index].userDetail?.profileImage??"",round: 15,width: double.infinity,height: double.infinity,boxFit: BoxFit.cover,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("${inboxState.threadList[index].userDetail?.firstName??""}, ",style: AppTextStyle.font20.copyWith(fontWeight: FontWeight.bold)),
                                      Text(inboxState.threadList[index].userDetail?.age.toString()??"",style: AppTextStyle.font25.copyWith(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  decoration:  BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    )
                                  ),
                                  child:  Row(
                                    children: [
                                      Expanded(child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: SvgPicture.asset(AppAssets.cancelICon,height: double.infinity),
                                        ))),
                                      Container(height: double.infinity,width: 2,color: AppColors.borderGreyColor),
                                      Expanded(child: GestureDetector(
                                        onTap: () {
                                          Go.to(context, ChatScreen(model: inboxState.threadList[index]));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: SvgPicture.asset("assets/images/svg/message.svg",height: double.infinity,colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            )
                            ],
                          ),
                        );
                      });
                    }
                  ),
                ),
            
            ],
          ),
        );
      }
    );
  }
}

