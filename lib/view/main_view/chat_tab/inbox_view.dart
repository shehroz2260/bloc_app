import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/main_view/chat_tab/chat_view.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_bloc.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_event.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  @override
  void initState() {
    context.read<InboxBloc>().add(ThreadListener(context: context));
    super.initState();
  }
InboxBloc ancestorContext = InboxBloc();
  @override
  void didChangeDependencies() {
   ancestorContext = MyInheritedWidget(bloc: context.read<InboxBloc>(),child: const SizedBox()).bloc;
    super.didChangeDependencies();
  }
  @override
  void dispose() {
   ancestorContext.add(OnDispose());
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<InboxBloc, InboxState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeight(height: 60),
              Text("Messages", style: AppTextStyle.font25.copyWith(color: AppColors.blackColor)),
              const AppHeight(height: 10),
              const CustomTextField(hintText: "Search...",isSowPrefixcon: true),
              const AppHeight(height: 15),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: List.generate(state.threadList.length, (index) {
                    return GestureDetector(
                      onTap: (){
                        Go.to(context,ChatScreen(model: state.threadList[index]));},
                      behavior: HitTestBehavior.opaque,
                      
                      child:  Container(
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 25),
                        child: Row(
                          children: [
                            AppCacheImage(imageUrl: state.threadList[index].userDetail?.profileImage??"",height: 60,width: 60,round: 60),
                             const AppWidth(width: 10),
                             Expanded(
                               child: Column(
                                 children: [
                                   Row(
                                     children: [
                                       Expanded(
                                         child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                             Text(state.threadList[index].userDetail?.firstName??"",style: AppTextStyle.font16.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold),),
                                            Text(state.threadList[index].lastMessage,maxLines: 1,style: AppTextStyle.font16.copyWith(color: AppColors.blackColor)),
                                          ],
                                                                   ),
                                       ),
                                       Column(
                                     children: [
                                       Text(timeago.format(
                                                            state.threadList[index].lastMessageTime,
                                                            locale: 'en_short',
                                                          ),),
                                                          if(state.threadList[index].senderId != (FirebaseAuth.instance.currentUser?.uid??"") && state.threadList[index].messageCount != 0)
                                                           Container(
                                                        padding:
                                                            const EdgeInsets.all(7),
                                                        decoration:  BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: AppColors.redColor,
                                                        ),
                                                        child: Text(
                                                          state.threadList[index].messageCount.toString(),
                                                          style:  TextStyle(
                                                              color: AppColors.whiteColor,
                                                              fontSize: 10),
                                                        ),
                                                      ),
                                     ],
                                   )
                                     ],
                                   ),
                              const Spacer(),
                                   Container(
                                    height: 1.5,
                                    color: AppColors.borderGreyColor,
                                   )
                                 ],
                               ),
                             ),
                             
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ))
            ],
          );
        },
      ),
    );
  }
}


class MyInheritedWidget extends InheritedWidget {
  final InboxBloc bloc;

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