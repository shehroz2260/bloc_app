import 'dart:async';
import 'package:chat_with_bloc/model/posts_model.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/services/firebase_services_storage.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostState(postList: [], limit: 20)) {
    on<ListenPost>(_onListenPosts);
    on<ListPostModel>(_onListPostModel);
    // on<OnPostLoad>(_onPostLoad);
    on<OnDispose>(_onDispose);
    on<OnClearData>(_onClearData);
    on<OnDelete>(_onDelete);
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
        .orderBy("createdAt", descending: true);

    subs = ref.snapshots().listen((value) async {
      if (value.docs.isEmpty) {
        return;
      }
      add(OnClearData());
      for (final e in value.docs) {
        var chat = PostsModel.fromMap(e.data());
        // if (state.postList.where((e) => e.id == chat.id).isNotEmpty) return;
        if (!event.context
                .read<UserBaseBloc>()
                .state
                .userData
                .matches
                .contains(chat.uid) &&
            chat.uid != event.context.read<UserBaseBloc>().state.userData.uid) {
          return;
        }
        final snapShow = await FirebaseFirestore.instance
            .collection(UserModel.tableName)
            .doc(chat.uid)
            .get();
        chat.userDetail = UserModel.fromMap(snapShow.data()!);
        add(ListPostModel(postsModel: chat));
      }
    });
  }

  _onListPostModel(ListPostModel event, Emitter<PostState> emit) {
    state.postList.add(event.postsModel);
    emit(state.copyWith(postList: state.postList));
  }

  // _onPostLoad(OnPostLoad event, Emitter<PostState> emit) async {
  //   if (state.limit < 20) {
  //     return;
  //   }
  //   Query<Map<String, dynamic>> snapShotQuery;
  //   snapShotQuery = FirebaseFirestore.instance
  //       .collection(PostsModel.tableName)
  //       .orderBy("createdAt", descending: true)
  //       .limit(20);
  //   if (lastDocument != null) {
  //     snapShotQuery = snapShotQuery.startAfterDocument(lastDocument!);
  //   }
  //   final snapShot = await snapShotQuery.get();
  //   List<PostsModel> messagesLIst = [];
  //   for (final e in snapShot.docs) {
  //     final model = PostsModel.fromMap(e.data());
  //     if (!event.context
  //             .read<UserBaseBloc>()
  //             .state
  //             .userData
  //             .matches
  //             .contains(model.uid) &&
  //         model.uid != event.context.read<UserBaseBloc>().state.userData.uid) {
  //       continue;
  //     }
  //     lastDocument = e;
  //     final snapShow = await FirebaseFirestore.instance
  //         .collection(UserModel.tableName)
  //         .doc(model.uid)
  //         .get();
  //     model.userDetail = UserModel.fromMap(snapShow.data()!);
  //     messagesLIst.add(model);
  //   }
  //   // var messagesLIst = snapShot.docs.map((e) {
  //   //   lastDocument = e;
  //   //   final model = PostsModel.fromMap(e.data());
  //   //   if (!event.context.read<UserBaseBloc>().state.userData.matches.contains(model.uid) && model.uid != event.context.read<UserBaseBloc>().state.userData.uid){
  //   //     continue;
  //   //   }
  //   //     return PostsModel.fromMap(e.data());
  //   // }).toList();
  //   state.postList.addAll(messagesLIst);
  //   emit(state.copyWith(
  //     limit: messagesLIst.length,
  //     postList: state.postList,
  //   ));
  //   add(ListenPost(context: event.context));
  // }

  _onDispose(OnDispose event, Emitter<PostState> emit) async {
    await subs?.cancel();
  }

  _onClearData(OnClearData event, Emitter<PostState> emit) {
    emit(state.copyWith(postList: []));
  }

  _onDelete(OnDelete event, Emitter<PostState> emit) async {
    state.postList.removeWhere((element) => element.id == event.postsModel.id);
    emit(state.copyWith(postList: state.postList));

    await FirebaseFirestore.instance
        .collection(PostsModel.tableName)
        .doc(event.postsModel.id)
        .delete();
    if (event.postsModel.imageList.isNotEmpty) {
      for (final e in event.postsModel.imageList) {
        await FirebaseStorageService().deleteFile(e, event.context);
      }
    }
  }
}
