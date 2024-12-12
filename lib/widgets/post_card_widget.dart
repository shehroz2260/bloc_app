import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  void dispose() async {
    await sub?.cancel();
    super.dispose();
  }

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
                imageUrl: widget.data.avatar,
                height: 50,
                width: 50,
                round: 50,
              ),
              const AppWidth(width: 10),
              Text(widget.data.userName)
            ],
          ),
          const AppHeight(height: 10),
          if (widget.data.imageList.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.data.imageList.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AppCacheImage(
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
                        print("^^^^^^^^^^^^^^^^^");
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
                const Text("Comment"),
                const Icon(Icons.share)
              ],
            ),
          )
        ],
      ),
    );
  }
}
