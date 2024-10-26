import 'package:chat_with_bloc/model/thread_model.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/chat_bloc.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/chat_event.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/chat_state.dart';
import 'package:chat_with_bloc/widgets/user_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../src/app_colors.dart';
import '../../../widgets/app_cache_image.dart';
import '../../../widgets/chat_bubble.dart';
import '../../../widgets/custom_text_field.dart';
import 'video_call/video_calling_page.dart';

class ChatScreen extends StatefulWidget {
  final ThreadModel model;
  const ChatScreen({super.key, required this.model});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = TextEditingController();
  ScrollController scrollController = ScrollController();
 
    void onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
     context.read<ChatBloc>().add(LoadChat(thradId: widget.model.threadId));
    }
  } 
  @override
  void initState() {
    scrollController.addListener(onScroll);
  context.read<ChatBloc>().add(LoadChat(thradId: widget.model.threadId));
  context.read<ChatBloc>().add(InitiaLizeAudioController());
    super.initState();
  }
  Signaling signaling = Signaling();
  ChatBloc ancestorContext = ChatBloc();
  @override
  void didChangeDependencies() {
   ancestorContext = MyInheritedWidget(bloc: context.read<ChatBloc>(),child: const SizedBox()).bloc;
    super.didChangeDependencies();
  }
  @override
  void dispose() {
   ancestorContext.add(ClearData());
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(child: BlocBuilder<ChatBloc,ChatState>(
        builder: (context,state) {
          return Column(
            children: [
              Container(
                width: mediaQuery.width,
                color: Colors.green.withOpacity(0.5),
                alignment: Alignment.center,
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:  Row(
                  children: [
                    GestureDetector(
                      onTap: ()=> Go.back(context),
                      child: const SizedBox(
                        height: 30,
                        width: 30,
                        child: Icon(Icons.arrow_back_ios_new))),
                     const AppWidth(width: 20),
                      GestureDetector(
                       onTap: () {
                        Go.to(context, ProfilePage(user: widget.model.userDetail??UserModel.emptyModel));
                        },
                        child: Row(
                         children: [
                           AppCacheImage(imageUrl: widget.model.userDetail?.profileImage??"",height: 50,width: 50,round: 50),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.model.userDetail?.firstName??""),
                              Text(widget.model.userDetail?.email??""),
                              ],
                            ),
                         ],
                       ),
                      ),
                      GestureDetector(
                        onTap: (){
                         Go.to(context,  MyHomePage(threadId: widget.model.threadId,isCreateRoom: true,roomId: "",userModel: widget.model.userDetail??UserModel.emptyModel,));
                        },
                        child: Icon(Icons.video_call,color: AppColors.whiteColor,size: 40,))
                  ],
                ),
              ),
              state.isLoading?
              const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.pink))):
              Expanded(child: Container(
                width: mediaQuery.width,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: state.messageList.length,
                  reverse: true,
                  controller: scrollController,

                  itemBuilder: (context, index){
                    var data = state.messageList[index];
                    return ChatBubble(
                      key: UniqueKey(),
                      userModel: widget.model.userDetail?? UserModel.emptyModel, data: data,showTime: index == state.messageList.length-1 ||state.messageList[index]
            .messageTime
            .difference(state.messageList[index + 1].messageTime)
            .inHours >
        1);}),
              )),
              if(state.messageSending)
              const LinearProgressIndicator(color: Colors.pink),
              if(state.messageSending) const SizedBox(height: 4),
              ChatTextField(
                onChanged: (value) {
                  context.read<ChatBloc>().add(OnChangeTextField(text: value));
                },
                duration: state.duration,
                pickFile: state.pickFile,
                thumbnail: state.thumbnail,
              controller: _chatController,
              isDisable: _chatController.text.isEmpty && state.thumbnail == null && state.pickFile == null,
              isLoading: state.isLoading,
              isRecording: state.isRecording,
              pickFiles: (){
                context.read<ChatBloc>().add(PickFileEvent(context: context));
              },
              sendMessage: state.messageSending ? (){}: (){
                context.read<ChatBloc>().add(SendMessage(threadId: widget.model.threadId, context: context,textEditingController: _chatController));
              },
              startOrStopRecording: (){
                context.read<ChatBloc>().add(StartOrStopRecording(context: context, threadId: widget.model.threadId));
              },
              ),
              const SizedBox(height: 14)
            ],
          );
        }
      )),
    );
  }
}



class MyInheritedWidget extends InheritedWidget {
  final ChatBloc bloc;

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