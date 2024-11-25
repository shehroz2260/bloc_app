import 'package:chat_with_bloc/model/thread_model.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/chat_bloc.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/chat_event.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/chat_state.dart';
import 'package:chat_with_bloc/widgets/user_detail_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../src/app_colors.dart';
import '../../../src/app_text_style.dart';
import '../../../widgets/app_cache_image.dart';
import '../../../widgets/chat_bubble.dart';
import '../../../widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      context
          .read<ChatBloc>()
          .add(LoadChat(thradId: widget.model.threadId, model: widget.model));
      context
          .read<ChatBloc>()
          .add(OnListenThread(context: context, threadModel: widget.model));
    }
  }

  @override
  void initState() {
    scrollController.addListener(onScroll);
    context
        .read<ChatBloc>()
        .add(ListenUserEvent(id: widget.model.userDetail?.uid ?? ""));
    context
        .read<ChatBloc>()
        .add(LoadChat(thradId: widget.model.threadId, model: widget.model));
    context
        .read<ChatBloc>()
        .add(OnListenThread(threadModel: widget.model, context: context));
    context.read<ChatBloc>().add(InitiaLizeAudioController());
    super.initState();
  }

  // Signaling signaling = Signaling();
  ChatBloc ancestorContext = ChatBloc();
  @override
  void didChangeDependencies() {
    ancestorContext = MyInheritedWidget(
            bloc: context.read<ChatBloc>(), child: const SizedBox())
        .bloc;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    ancestorContext.add(ClearData());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const AppHeight(height: 70),
              Row(
                children: [
                  GestureDetector(
                      onTap: () => Go.back(context),
                      child: Icon(Icons.arrow_back_ios_new_outlined,
                          color: theme.textColor)),
                  const AppWidth(width: 10),
                  GestureDetector(
                    onTap: () {
                      Go.to(
                          context,
                          ProfilePage(
                              user: widget.model.userDetail ??
                                  UserModel.emptyModel));
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: AppColors.redColor, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(3),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            shape: BoxShape.circle),
                        padding: const EdgeInsets.all(3),
                        child: AppCacheImage(
                            imageUrl:
                                widget.model.userDetail?.profileImage ?? "",
                            height: 60,
                            width: 60,
                            round: 60),
                      ),
                    ),
                  ),
                  const AppWidth(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.model.userDetail?.firstName ?? "",
                            style: AppTextStyle.font20.copyWith(
                                color: theme.textColor,
                                fontWeight: FontWeight.bold)),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(UserModel.tableName)
                              .doc(widget.model.userDetail?.uid ?? "")
                              .snapshots(),
                          builder: (context, snapshot) {
                            final isOnline =
                                snapshot.data?.data()?["isOnline"] ?? false;
                            return Row(
                              children: [
                                Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isOnline
                                          ? Colors.green
                                          : AppColors.redColor),
                                ),
                                const AppWidth(width: 6),
                                Text(
                                  isOnline ? 'Online' : 'Offline',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      context.read<ChatBloc>().add(OpenOptions(
                          context: context,
                          userModel: widget.model.userDetail!));
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderGreyColor)),
                      alignment: Alignment.center,
                      child: const Icon(Icons.more_vert),
                    ),
                  )
                ],
              ),
              const AppHeight(height: 30),
              if (state.isLoading)
                Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                  color: AppColors.redColor,
                ))),
              if (state.messageList.isEmpty && !state.isLoading)
                Expanded(
                    child: Center(
                        child: Text(AppLocalizations.of(context)!
                            .enterYourFirstMessage))),
              if (state.messageList.isNotEmpty && !state.isLoading)
                Expanded(
                    child: Container(
                  width: mediaQuery.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.messageList.length,
                      reverse: true,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        var data = state.messageList[index];
                        return ChatBubble(
                            key: UniqueKey(),
                            userModel:
                                widget.model.userDetail ?? UserModel.emptyModel,
                            data: data,
                            showTime: index == state.messageList.length - 1 ||
                                state.messageList[index].messageTime
                                        .difference(state
                                            .messageList[index + 1].messageTime)
                                        .inHours >
                                    1);
                      }),
                )),
              if (state.messageSending)
                const LinearProgressIndicator(color: Colors.pink),
              if (state.messageSending) const SizedBox(height: 4),
              ChatTextField(
                onChanged: (value) {
                  context.read<ChatBloc>().add(OnChangeTextField(text: value));
                },
                duration: state.duration,
                pickFile: state.pickFile,
                thumbnail: state.thumbnail,
                controller: _chatController,
                isDisable: _chatController.text.isEmpty &&
                    state.thumbnail == null &&
                    state.pickFile == null,
                isLoading: state.isLoading,
                isRecording: state.isRecording,
                pickFiles: () {
                  context.read<ChatBloc>().add(PickFileEvent(context: context));
                },
                sendMessage: state.messageSending
                    ? () {}
                    : () {
                        context.read<ChatBloc>().add(SendMessage(
                            threadId: widget.model.threadId,
                            context: context,
                            textEditingController: _chatController,
                            threadModel: widget.model,
                            isForVc: false));
                      },
                startOrStopRecording: () {
                  context.read<ChatBloc>().add(StartOrStopRecording(
                      context: context,
                      threadId: widget.model.threadId,
                      model: widget.model));
                },
              ),
              const SizedBox(height: 14)
            ],
          ),
        );
      }),
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
