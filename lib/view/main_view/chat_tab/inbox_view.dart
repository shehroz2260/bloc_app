import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/main_view/chat_tab/chat_view.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_bloc.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_event.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            children: [
              const AppHeight(height: 50),
              Text("Chat", style: AppTextStyle.font25),
              const AppHeight(height: 20),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: List.generate(state.threadList.length, (index) {
                    return GestureDetector(
                      onTap: (){
                        Go.to(context,ChatScreen(model: state.threadList[index]));},
                      behavior: HitTestBehavior.opaque,
                      child: ListTile(
                        leading: AppCacheImage(imageUrl: state.threadList[index].userDetail?.profileImage??"",width: 40,height: 40,round: 40),
                        title: Text(state.threadList[index].userDetail?.name??"",style: AppTextStyle.font16),
                        subtitle: Text(state.threadList[index].userDetail?.email??"",style: AppTextStyle.font16.copyWith(fontSize: 12,color: AppColors.whiteColor.withOpacity(0.7)),),
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