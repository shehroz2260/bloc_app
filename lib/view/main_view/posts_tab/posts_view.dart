import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/view/main_view/posts_tab/create_post_view.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/post_bloc/post_bloc.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/post_bloc/post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../src/app_colors.dart';
import '../../../src/app_text_style.dart';
import '../../../src/width_hieght.dart';
import '../../../view_model/chat_bloc/post_bloc/post_event.dart';
import '../../../widgets/post_card_widget.dart';

class PostsView extends StatefulWidget {
  const PostsView({
    super.key,
  });

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  @override
  void initState() {
    context.read<PostBloc>().add(OnPostLoad(context: context));
    super.initState();
  }

  PostBloc ancestorContext = PostBloc();
  @override
  void didChangeDependencies() {
    ancestorContext = MyInheritedWidget(
            bloc: context.read<PostBloc>(), child: const SizedBox())
        .bloc;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    ancestorContext.add(OnDispose());
    super.dispose();
  }

  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeight(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Posts",
                    style:
                        AppTextStyle.font25.copyWith(color: theme.textColor)),
                GestureDetector(
                    onTap: () {
                      Go.to(context, const CreatePostView());
                    },
                    child: const Icon(Icons.add))
              ],
            ),
            const AppHeight(height: 20),
            Expanded(
                child: SizedBox(
              width: double.infinity,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.postList.length,
                  // reverse: true,
                  controller: controller,
                  itemBuilder: (context, index) {
                    var data = state.postList[index];
                    return PostCards(data: data);
                  }),
            )),
          ],
        ),
      );
    });
  }
}

class MyInheritedWidget extends InheritedWidget {
  final PostBloc bloc;

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
