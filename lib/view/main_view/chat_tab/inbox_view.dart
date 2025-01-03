// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_bloc.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_event.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_state.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';

import '../../../widgets/thread_widget.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    context.read<InboxBloc>().add(ThreadListener(context: context));
    super.initState();
  }

  InboxBloc ancestorContext = InboxBloc();
  @override
  void didChangeDependencies() {
    ancestorContext = MyInheritedWidget(
            bloc: context.read<InboxBloc>(), child: const SizedBox())
        .bloc;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    ancestorContext.add(OnDispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<InboxBloc, InboxState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeight(height: 60),
              Text(AppLocalizations.of(context)!.messages,
                  style: AppTextStyle.font25.copyWith(color: theme.textColor)),
              const AppHeight(height: 10),
              CustomTextField(
                hintText: AppLocalizations.of(context)!.search,
                isSowPrefixcon: true,
                onChange: (value) {
                  context.read<InboxBloc>().add(OnSearch(value: value));
                },
              ),
              const AppHeight(height: 15),
              if (state.threadList.isEmpty)
                Expanded(
                    child: Center(
                        child: Text(
                            AppLocalizations.of(context)!.thereIsNoMatched))),
              if (state.threadList.isNotEmpty)
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(state.threadList.length, (index) {
                      return (state.threadList[index].userDetail?.firstName ??
                                  "")
                              .toLowerCase()
                              .contains(state.searchText.toLowerCase())
                          ? ThreadWidget(threadModel: state.threadList[index])
                          : const SizedBox();
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

  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant MyInheritedWidget oldWidget) {
    return false;
  }
}














  // void _imageView(String image) async {
  // showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         contentPadding: EdgeInsets.zero,
  //         content: AppCacheImage(
  //           imageUrl: image,
  //           height: 400,
  //           boxFit: BoxFit.fitWidth,
  //           onTap: () {
  //             Go.off(context, ImageView(imageUrl: image));
  //           },
  //           // width: double.infinity,
  //         ),
  //       );
  //     });
  // }
// void _openChatView(ThreadModel thread)async{
//   final id = thread.threadId;
//    scrollController.addListener((){
//        if (scrollController.position.pixels ==
//         scrollController.position.maxScrollExtent) {
//      context.read<ChatBloc>().add(LoadChat(thradId: id));
//     }
//    });

//      context.read<ChatBloc>().add(LoadChat(thradId: thread.threadId));
//   context.read<ChatBloc>().add(OnListenThread(threadModel: thread,context: context));
//   context.read<ChatBloc>().add(InitiaLizeAudioController());
//   await showModalBottomSheet(
//     isScrollControlled: true,
//     context: context, builder: (context){
//     return Container(
//      height: MediaQuery.of(context).size.height *.88,
//      decoration: BoxDecoration(
//       color: AppColors.whiteColor,
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(40),
//         topRight: Radius.circular(40)
//       )
//      ),
//      child:  Padding(
//        padding: const EdgeInsets.symmetric(horizontal: 40),
//        child: BlocBuilder<ChatBloc, ChatState>(
//          builder: (context,state) {
//            return Column(
//             children: [
//               const AppHeight(height: 35),

//               const AppHeight(height: 30),
//             state.messageList.isEmpty?
//               const Expanded(child: Center(child: Text("Enter your first message"))):

//               Expanded(child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: ListView.builder(
//                   itemCount: state.messageList.length,
//                   reverse: true,
//                   controller: scrollController,

//                   itemBuilder: (context, index){
//                     var data = state.messageList[index];
//                     return ChatBubble(
//                       key: UniqueKey(),
//                       userModel: thread.userDetail?? UserModel.emptyModel, data: data,showTime: index == state.messageList.length-1 ||state.messageList[index]
//             .messageTime
//             .difference(state.messageList[index + 1].messageTime)
//             .inHours >
//         1);}),
//               )),

//                if(state.messageSending)
//               const LinearProgressIndicator(color: Colors.pink),
//               if(state.messageSending) const SizedBox(height: 4),
//               ChatTextField(
//                 onChanged: (value) {
//                   context.read<ChatBloc>().add(OnChangeTextField(text: value));
//                 },
//                 duration: state.duration,
//                 pickFile: state.pickFile,
//                 thumbnail: state.thumbnail,
//               controller: _chatController,
//               isDisable: _chatController.text.isEmpty && state.thumbnail == null && state.pickFile == null,
//               isLoading: state.isLoading,
//               isRecording: state.isRecording,
//               pickFiles: (){
//                 context.read<ChatBloc>().add(PickFileEvent(context: context));
//               },
//               sendMessage: state.messageSending ? (){}: (){
//                 context.read<ChatBloc>().add(SendMessage(threadId: thread.threadId, context: context,textEditingController: _chatController));
//               },
//               startOrStopRecording: (){
//                 context.read<ChatBloc>().add(StartOrStopRecording(context: context, threadId: thread.threadId));
//               },
//               ),
//               const SizedBox(height: 14)
//             ],
//            );
//          }
//        ),
//      ),
//     );
//   });
// context.read<ChatBloc>().add(ClearData());
// scrollController.removeListener((){
//   log("^^^^^^^^^^^^^^^^^^^^^^^^^");
// });
//   // chatBloc.add(ClearData());
// }