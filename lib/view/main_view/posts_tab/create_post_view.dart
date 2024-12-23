import 'dart:io';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/view_model/create_post_bloc/create_post_bloc.dart';
import 'package:chat_with_bloc/view_model/create_post_bloc/create_post_state.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/posts_model.dart';
import '../../../src/app_text_style.dart';
import '../../../src/width_hieght.dart';
import '../../../view_model/create_post_bloc/create_post_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePostView extends StatefulWidget {
  final PostsModel? postModel;
  const CreatePostView({super.key, this.postModel});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final _textController = TextEditingController();
  @override
  void initState() {
    if (widget.postModel != null) {
      _textController.text = widget.postModel!.text;
      context.read<CreatePostBloc>().add(OnUpdatePost(
            postModel: widget.postModel!,
          ));
    }
    super.initState();
  }

  CreatePostBloc ancestorContext = CreatePostBloc();
  @override
  void didChangeDependencies() {
    ancestorContext = MyInheritedWidget(
            bloc: context.read<CreatePostBloc>(), child: const SizedBox())
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
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeight(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomBackButton(),
                Text(
                    widget.postModel == null
                        ? AppLocalizations.of(context)!.createPost
                        : AppLocalizations.of(context)!.editPost,
                    style:
                        AppTextStyle.font25.copyWith(color: theme.textColor)),
                // const AppWidth(width: 50)
                GestureDetector(
                  onTap: () {
                    context.read<CreatePostBloc>().add(OnPostCreate(
                        model: widget.postModel,
                        controller: _textController,
                        context: context));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: AppColors.redColor),
                    child: Text(
                      widget.postModel == null
                          ? AppLocalizations.of(context)!.post
                          : AppLocalizations.of(context)!.update,
                      style: AppTextStyle.font16,
                    ),
                  ),
                )
              ],
            ),
            const AppHeight(height: 20),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(
                    textEditingController: _textController,
                    hintText: AppLocalizations.of(context)!.whatsOnYourMind,
                    maxLines: 5,
                  ),
                  const AppHeight(height: 20),
                ],
              ),
            )),
            BlocBuilder<CreatePostBloc, CreatePostState>(
                builder: (context, state) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 10, left: 10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColors.borderGreyColor))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (state.images.isEmpty)
                      Text(
                        AppLocalizations.of(context)!.images,
                        style: AppTextStyle.font20.copyWith(color: Colors.grey),
                      ),
                    if (state.images.isNotEmpty)
                      Expanded(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(state.images.length, (index) {
                            return Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: state.images[index]
                                              .contains("http")
                                          ? NetworkImage(state.images[index])
                                          : FileImage(
                                              File(state.images[index])),
                                      fit: BoxFit.cover)),
                              margin: const EdgeInsets.only(right: 10),
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<CreatePostBloc>()
                                        .add(CancelImage(index: index));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: AppColors.redColor,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  )),
                            );
                          }),
                        ),
                      )),
                    GestureDetector(
                        onTap: () {
                          context
                              .read<CreatePostBloc>()
                              .add(PickImages(context: context));
                        },
                        child: const Icon(Icons.attachment))
                  ],
                ),
              );
            }),
            const AppHeight(height: 10)
          ],
        ),
      ),
    );
  }
}

class MyInheritedWidget extends InheritedWidget {
  final CreatePostBloc bloc;

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
