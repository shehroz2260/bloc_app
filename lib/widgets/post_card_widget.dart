import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/view/main_view/posts_tab/comment_view.dart';
import 'package:chat_with_bloc/view/main_view/posts_tab/create_post_view.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/post_bloc/post_bloc.dart';
import 'package:chat_with_bloc/view_model/chat_bloc/post_bloc/post_event.dart';
import 'package:chat_with_bloc/widgets/image_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/like_model.dart';
import '../model/posts_model.dart';
import '../src/app_colors.dart';
import '../src/width_hieght.dart';
import 'app_cache_image.dart';

class PostCards extends StatefulWidget {
  const PostCards({
    super.key,
    required this.data,
  });

  final PostsModel data;

  @override
  State<PostCards> createState() => _PostCardsState();
}

class _PostCardsState extends State<PostCards> {
  int likes = 0;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? sub;
  @override
  void initState() {
    sub = FirebaseFirestore.instance
        .collection(PostsModel.tableName)
        .doc(widget.data.id)
        .collection(LikeModel.tableName)
        .snapshots()
        .listen((event) {
      setState(() {
        likes = event.size;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    ondisPose();

    super.dispose();
  }

  ondisPose() async {
    await sub?.cancel();
  }

  String? selectedItem;
  final List<Map<String, dynamic>> items = [
    {
      "item": "Edit",
      "icon": Icons.edit,
    },
    {
      "item": "Delete",
      "icon": Icons.delete,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppColors.borderGreyColor,
      decoration: BoxDecoration(
          color: AppColors.borderGreyColor,
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10),
      // alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppCacheImage(
                onTap: () {
                  Go.to(
                      context,
                      ImageView(
                          imageUrl:
                              widget.data.userDetail?.profileImage ?? ""));
                },
                imageUrl: widget.data.userDetail?.profileImage ?? "",
                height: 50,
                width: 50,
                round: 50,
              ),
              const AppWidth(width: 10),
              Expanded(
                child: Text(
                    "${widget.data.userDetail?.firstName ?? ""} ${widget.data.userDetail?.lastName ?? ""}"),
              ),
              if (widget.data.uid ==
                  (FirebaseAuth.instance.currentUser?.uid ?? ""))
                DropdownButton<String>(
                  underline: const SizedBox(),
                  icon: const Icon(Icons.more_vert),
                  items: items.map((Map<String, dynamic> item) {
                    return DropdownMenuItem<String>(
                      value: item["item"],
                      child: Row(
                        children: [
                          Icon(item["icon"]),
                          const AppWidth(width: 10),
                          Text(item["item"]),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) async {
                    if (newValue == items[0]["item"]) {
                      Go.to(context, CreatePostView(postModel: widget.data));
                    } else {
                      final res = await showOkCancelAlertDialog(
                          context: context,
                          message: "Do you really want to delete this post?",
                          title: "Are you sure?");
                      if (res == OkCancelResult.cancel) return;
                      context.read<PostBloc>().add(
                          OnDelete(postsModel: widget.data, context: context));
                    }
                    setState(() {
                      selectedItem = newValue;
                    });
                  },
                ),
              const AppWidth(width: 10)
            ],
          ),
          const AppHeight(height: 10),
          if (widget.data.imageList.isNotEmpty &&
              widget.data.imageList.length == 1)
            AppCacheImage(
              imageUrl: widget.data.imageList.first,
              width: double.infinity,
              onTap: () {
                Go.to(
                    context, ImageView(imageUrl: widget.data.imageList.first));
              },
              height: 150,
              boxFit: BoxFit.fill,
              round: 20,
            ),
          if (widget.data.imageList.isNotEmpty &&
              widget.data.imageList.length > 1)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.data.imageList.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AppCacheImage(
                      onTap: () {
                        Go.to(context,
                            ImageView(imageUrl: widget.data.imageList[index]));
                      },
                      boxFit: BoxFit.fill,
                      imageUrl: widget.data.imageList[index],
                      height: 150,
                      width: 200,
                    ),
                  );
                }),
              ),
            ),
          const AppHeight(height: 5),
          if (widget.data.text.isNotEmpty) Text(widget.data.text),
          const AppHeight(height: 10),
          Container(
            color: AppColors.blackColor,
            height: 1,
            width: double.infinity,
          ),
          const AppHeight(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        LikeModel model = LikeModel(
                            likeruid:
                                FirebaseAuth.instance.currentUser?.uid ?? "");
                        model.addNewLikeOrUpdate(widget.data);
                      },
                      child: Icon(
                        Icons.favorite_border,
                        color: AppColors.redColor,
                      ),
                    ),
                    Text(likes.toString())
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      Go.to(context, CommentView(postsModel: widget.data));
                    },
                    child: const Text("Comment")),
                const Icon(Icons.share)
              ],
            ),
          )
        ],
      ),
    );
  }
}
