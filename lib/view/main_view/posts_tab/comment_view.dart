import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/like_model.dart';
import 'package:chat_with_bloc/model/posts_model.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/utils/app_funcs.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../src/app_text_style.dart';
import '../../../src/width_hieght.dart';
import '../../../widgets/custom_button.dart';

class CommentView extends StatefulWidget {
  final PostsModel postsModel;
  const CommentView({super.key, required this.postsModel});

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  final _commentController = TextEditingController();
  List<CommentModel> commentList = [];
  int limit = 20;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? sub;
  _getComments() {
    sub = FirebaseFirestore.instance
        .collection(PostsModel.tableName)
        .doc(widget.postsModel.id)
        .collection(CommentModel.tableName)
        .orderBy("createdAt", descending: true)
        .limit(1)
        .snapshots()
        .listen((value) async {
      if (value.docs.isEmpty) return;
      var chat = CommentModel.fromMap(value.docs[0].data());
      if (commentList.where((e) => e.id == chat.id).isNotEmpty) return;
      final snapShot = await FirebaseFirestore.instance
          .collection(UserModel.tableName)
          .doc(chat.uid)
          .get();
      setState(() {
        if (snapShot.exists) {
          chat.userData = UserModel.fromMap(snapShot.data()!);
        }
        commentList.insert(0, chat);
      });
    });
  }

  DocumentSnapshot? lastDocument;
  Future<void> _onCommentLoad() async {
    if (limit < 20) {
      return;
    }
    Query<Map<String, dynamic>> snapShotQuery;
    snapShotQuery = FirebaseFirestore.instance
        .collection(PostsModel.tableName)
        .doc(widget.postsModel.id)
        .collection(CommentModel.tableName)
        .orderBy("createdAt", descending: true)
        .limit(20);
    if (lastDocument != null) {
      snapShotQuery = snapShotQuery.startAfterDocument(lastDocument!);
    }
    final snapShot = await snapShotQuery.get();
    List<CommentModel> messagesLIst = [];
    for (final e in snapShot.docs) {
      final model = CommentModel.fromMap(e.data());

      lastDocument = e;
      final snapShot = await FirebaseFirestore.instance
          .collection(UserModel.tableName)
          .doc(model.uid)
          .get();
      if (snapShot.exists) {
        model.userData = UserModel.fromMap(snapShot.data()!);
      }
      messagesLIst.add(model);
    }

    setState(() {
      commentList.addAll(messagesLIst);
      limit = commentList.length;
    });
  }

  ScrollController scrollController = ScrollController();

  void onScroll() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      await _onCommentLoad();
    }
  }

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  onDispose() async {
    await sub?.cancel();
  }

  @override
  void initState() {
    oninitData();
    super.initState();
  }

  oninitData() async {
    scrollController.addListener(onScroll);
    await _onCommentLoad();
    _getComments();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const AppHeight(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomBackButton(),
                Text("Comments",
                    style:
                        AppTextStyle.font25.copyWith(color: theme.textColor)),
                const AppWidth(width: 50)
              ],
            ),
            const AppHeight(height: 20),
            Expanded(
                child: SizedBox(
              width: double.infinity,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: commentList.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: BoxDecoration(
                            color: AppColors.borderGreyColor,
                            borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              AppCacheImage(
                                  imageUrl: commentList[index]
                                          .userData
                                          ?.profileImage ??
                                      "",
                                  height: 50,
                                  width: 50,
                                  round: 50),
                              const AppWidth(width: 15),
                              Text(
                                  "${commentList[index].userData?.firstName ?? ""} ${commentList[index].userData?.lastName ?? ""}")
                            ]),
                            const AppHeight(height: 10),
                            Text(
                              commentList[index].comment,
                              style: AppTextStyle.font16
                                  .copyWith(color: AppColors.blackColor),
                            ),
                            const AppHeight(height: 10),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: AppColors.blackColor,
                            ),
                            const AppHeight(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                DateFormat("hh:mm")
                                    .format(commentList[index].createdAt),
                              ),
                            ),
                          ],
                        ));
                  }),
            )),
            const AppHeight(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "Enter comment",
                    textEditingController: _commentController,
                  ),
                ),
                const AppWidth(width: 10),
                GestureDetector(
                    onTap: () async {
                      if (_commentController.text.isEmpty) {
                        showOkAlertDialog(
                            context: context,
                            message: "Enter something",
                            title: "Error");
                        return;
                      }
                      CommentModel model = CommentModel(
                          uid: FirebaseAuth.instance.currentUser?.uid ?? "",
                          comment: _commentController.text,
                          createdAt: DateTime.now(),
                          id: AppFuncs.generateRandomString(15));

                      await FirebaseFirestore.instance
                          .collection(PostsModel.tableName)
                          .doc(widget.postsModel.id)
                          .collection(CommentModel.tableName)
                          .doc(model.id)
                          .set(model.toMap());

                      _commentController.clear();
                    },
                    child: Icon(Icons.send, color: AppColors.redColor))
              ],
            ),
            const AppHeight(height: 10),
          ],
        ),
      ),
    );
  }
}
