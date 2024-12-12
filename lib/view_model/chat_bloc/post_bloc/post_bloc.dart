import 'dart:async';
import 'package:chat_with_bloc/model/posts_model.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostState(postList: [], limit: 20)) {
    on<ListenPost>(_onListenPosts);
    on<ListPostModel>(_onListPostModel);
    on<OnPostLoad>(_onPostLoad);
    on<OnDispose>(_onDispose);
  }
  DocumentSnapshot? lastDocument;
  _onListenPosts(ListenPost event, Emitter<PostState> emit) async {
    await emit.forEach(_chatListenerStream(event), onData: (value) {
      return state.copyWith(postList: value.postList);
    });
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subs;
  Stream<PostState> _chatListenerStream(ListenPost event) async* {
    var ref = FirebaseFirestore.instance
        .collection(PostsModel.tableName)
        .orderBy("createdAt", descending: true)
        .limit(1);

    subs = ref.snapshots().listen((value) {
      if (value.docs.isEmpty) return;
      var chat = PostsModel.fromMap(value.docs[0].data());
      if (state.postList.where((e) => e.id == chat.id).isNotEmpty) return;
      if (!event.context
              .read<UserBaseBloc>()
              .state
              .userData
              .matches
              .contains(chat.uid) &&
          chat.uid != event.context.read<UserBaseBloc>().state.userData.uid) {
        return;
      }
      add(ListPostModel(postsModel: chat));
    });
  }

  _onListPostModel(ListPostModel event, Emitter<PostState> emit) {
    state.postList.insert(0, event.postsModel);
    emit(state.copyWith(postList: state.postList));
  }

  _onPostLoad(OnPostLoad event, Emitter<PostState> emit) async {
    if (state.limit < 20) {
      return;
    }
    final snapShot = await FirebaseFirestore.instance
        .collection(PostsModel.tableName)
        .orderBy("createdAt", descending: true)
        .limit(20)
        .get();
    List<PostsModel> messagesLIst = [];
    for (final e in snapShot.docs) {
      final model = PostsModel.fromMap(e.data());
      if (!event.context
              .read<UserBaseBloc>()
              .state
              .userData
              .matches
              .contains(model.uid) &&
          model.uid != event.context.read<UserBaseBloc>().state.userData.uid) {
        continue;
      }
      lastDocument = e;
      messagesLIst.add(model);
    }
    // var messagesLIst = snapShot.docs.map((e) {
    //   lastDocument = e;
    //   final model = PostsModel.fromMap(e.data());
    //   if (!event.context.read<UserBaseBloc>().state.userData.matches.contains(model.uid) && model.uid != event.context.read<UserBaseBloc>().state.userData.uid){
    //     continue;
    //   }
    //     return PostsModel.fromMap(e.data());
    // }).toList();
    state.postList.addAll(messagesLIst);
    emit(state.copyWith(
      limit: messagesLIst.length,
      postList: state.postList,
    ));
    add(ListenPost(context: event.context));
  }

  _onDispose(OnDispose event, Emitter<PostState> emit) async {
    await subs?.cancel();
  }
}
