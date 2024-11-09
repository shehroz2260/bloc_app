import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_bloc.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_event.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:chat_with_bloc/widgets/image_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../src/go_file.dart';
import 'chat_view.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  ScrollController scrollController = ScrollController();

  // final _chatController = TextEditingController();
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<InboxBloc, InboxState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeight(height: 60),
              Text("Messages",
                  style: AppTextStyle.font25
                      .copyWith(color: AppColors.blackColor)),
              const AppHeight(height: 10),
              CustomTextField(
                hintText: "Search...",
                isSowPrefixcon: true,
                onChange: (value) {
                  context.read<InboxBloc>().add(OnSearch(value: value));
                },
              ),
              const AppHeight(height: 15),
              if (state.threadList.isEmpty)
                const Expanded(
                    child: Center(child: Text("There is no matched"))),
              if (state.threadList.isNotEmpty)
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(state.threadList.length, (index) {
                      return (state.threadList[index].userDetail?.userName ??
                                  "")
                              .toLowerCase()
                              .contains(state.searchText.toLowerCase())
                          ? GestureDetector(
                              onTap: () {
                                Go.to(context,
                                    ChatScreen(model: state.threadList[index]));
                                // _openChatView(state.threadList[index]);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                height: 60,
                                margin: const EdgeInsets.only(bottom: 25),
                                child: Row(
                                  children: [
                                    AppCacheImage(
                                        onTap: () => _imageView(state
                                                .threadList[index]
                                                .userDetail
                                                ?.profileImage ??
                                            ""),
                                        imageUrl: state.threadList[index]
                                                .userDetail?.profileImage ??
                                            "",
                                        height: 60,
                                        width: 60,
                                        round: 60),
                                    const AppWidth(width: 10),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      state
                                                              .threadList[index]
                                                              .userDetail
                                                              ?.firstName ??
                                                          "",
                                                      style: AppTextStyle.font16
                                                          .copyWith(
                                                              color: AppColors
                                                                  .blackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    Text(
                                                        state
                                                                .threadList[
                                                                    index]
                                                                .lastMessage
                                                                .isEmpty
                                                            ? "Send your first message"
                                                            : state
                                                                .threadList[
                                                                    index]
                                                                .lastMessage,
                                                        maxLines: 1,
                                                        style: AppTextStyle
                                                            .font16
                                                            .copyWith(
                                                                color: AppColors
                                                                    .blackColor,
                                                                fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    timeago.format(
                                                      state.threadList[index]
                                                          .lastMessageTime,
                                                      locale: 'en_short',
                                                    ),
                                                  ),
                                                  if (state.threadList[index]
                                                              .senderId !=
                                                          (FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid ??
                                                              "") &&
                                                      state.threadList[index]
                                                              .messageCount !=
                                                          0)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              7),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            AppColors.redColor,
                                                      ),
                                                      child: Text(
                                                        state.threadList[index]
                                                            .messageCount
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .whiteColor,
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
                            )
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

  void _imageView(String image) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: AppCacheImage(
              imageUrl: image,
              height: 400,
              boxFit: BoxFit.fitWidth,
              onTap: () {
                Go.off(context, ImageView(imageUrl: image));
              },
              // width: double.infinity,
            ),
          );
        });
  }
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
