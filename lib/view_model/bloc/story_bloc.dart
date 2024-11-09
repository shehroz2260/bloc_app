import 'dart:async';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/story_model.dart';
import 'package:chat_with_bloc/services/firebase_services_storage.dart';
import 'package:chat_with_bloc/utils/app_funcs.dart';
import 'package:chat_with_bloc/utils/custom_image_picker.dart';
import 'package:chat_with_bloc/utils/media_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'story_event.dart';
import 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc()
      : super(StoryState(
            file: null,
            isLoading: false,
            storyList: [],
            thumbnail: null,
            otherList: [])) {
    on<PickFile>(_onPickFile);
    on<GetStory>(_getStory);
    on<UploadStory>(_uploadStory);
    on<FetchOthetStories>(_fetchOtherStories);
    on<ClearData>(_clearData);
    on<OnDisposeStory>(_onDispose);
    on<StoryListener>(_onChatListenerStream);
  }
  _onPickFile(PickFile event, Emitter<StoryState> emit) async {
    File? image;
    File? video;
    if (!event.isVideo) {
      image = await kImagePicker(context: event.context);
    }
    if (event.isVideo) {
      video = await kVideoPicker(context: event.context);
    }
    if ((image?.path ?? "").isNotEmpty && !event.isVideo) {
      emit(state.copyWith(file: image));
      add(UploadStory(
          context: event.context, type: MediaType.image, bloc: event.bloc));
    }
    if ((video?.path ?? "").isNotEmpty && event.isVideo) {
      final thumbnail = await AppFuncs.generateThumbNail(video?.path ?? "");
      emit(state.copyWith(file: video, thumbnail: File(thumbnail?.path ?? "")));
      add(UploadStory(
          context: event.context, type: MediaType.video, bloc: event.bloc));
    }
  }

  _uploadStory(UploadStory event, Emitter<StoryState> emit) async {
    final cUser = event.bloc.state.userData;
    emit(state.copyWith(isLoading: true));
    try {
      String url = "";
      String thumbnailUrl = "";
      if (event.type == MediaType.image) {
        url = await FirebaseStorageService().uploadImage(
            "storyImage/${AppFuncs.generateRandomString(10)}",
            state.file?.path ?? "");
      }
      if (event.type == MediaType.video) {
        thumbnailUrl = await FirebaseStorageService().uploadImage(
            "storyVideo/${AppFuncs.generateRandomString(10)}",
            state.thumbnail?.path ?? "");
      }

      StoryModel storyModel = StoryModel(
          thumbnail: thumbnailUrl,
          userImage: cUser.profileImage,
          id: AppFuncs.generateRandomString(15),
          userId: cUser.uid,
          userName: cUser.firstName,
          name: "",
          type: event.type,
          url: url,
          createdAt: DateTime.now());
      await FirebaseFirestore.instance
          .collection(StoryModel.tableName)
          .doc(AppFuncs.generateRandomString(10))
          .set(storyModel.toMap());
      emit(state.copyWith(file: File(""), isLoading: false));
    } on FirebaseException catch (e) {
      emit(state.copyWith(isLoading: false));
      showOkAlertDialog(
          context: event.context, message: e.message, title: "Error");
    }
  }

  _getStory(GetStory event, Emitter<StoryState> emit) async {
    await emit.forEach(_chatListenerStream(event), onData: (value) {
      return state.copyWith(storyList: value.storyList);
    });
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subs;
  Stream<StoryState> _chatListenerStream(GetStory event) async* {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    final last24HoursTimestamp = Timestamp.fromDate(last24Hours);
    var ref = FirebaseFirestore.instance.collection(StoryModel.tableName).where(
          "userId",
          isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "",
        );

    subs = ref
        .where("createdAt", isGreaterThanOrEqualTo: last24HoursTimestamp)
        .snapshots()
        .listen((value) {
      if (value.docs.isEmpty) return;
      add(ClearData());
      for (final e in value.docs) {
        var chat = StoryModel.fromMap(e.data());
        add(StoryListener(model: chat));
      }
    });
    ref
        .where("createdAt", isLessThan: last24HoursTimestamp)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (final e in value.docs) {
          final model = StoryModel.fromMap(e.data());
          await FirebaseStorageService().deleteFile(model.url, event.context);
          if (model.type == MediaType.video) {
            await FirebaseStorageService()
                .deleteFile(model.thumbnail, event.context);
          }
          e.reference.delete();
        }
      }
    });
  }

  _onChatListenerStream(StoryListener event, Emitter<StoryState> emit) {
    state.storyList.add(event.model);
    emit(state.copyWith(storyList: state.storyList));
  }

  _clearData(ClearData event, Emitter<StoryState> emit) async {
    emit(state.copyWith(storyList: []));
  }

  _onDispose(OnDisposeStory event, Emitter<StoryState> emit) async {
    await subs?.cancel();
    emit(state.copyWith(
        storyList: [],
        isLoading: false,
        file: File(""),
        otherList: [],
        thumbnail: File("")));
  }

  _fetchOtherStories(FetchOthetStories event, Emitter<StoryState> emit) async {
    emit(state.copyWith(isLoading: true));
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    final last24HoursTimestamp = Timestamp.fromDate(last24Hours);
    final snapShot = await FirebaseFirestore.instance
        .collection(StoryModel.tableName)
        .where("createdAt", isGreaterThanOrEqualTo: last24HoursTimestamp)
        .get();
    // emit(state.copyWith(isLoading: false));
    if (snapShot.docs.isEmpty) return;
    final mediaList =
        snapShot.docs.map((e) => StoryModel.fromMap(e.data())).toList();

    Map<String, List<StoryModel>> mediaMap = {};

    for (var media in mediaList) {
      if (mediaMap.containsKey(media.userId)) {
        mediaMap[media.userId]!.add(media);
      } else {
        mediaMap[media.userId] = [media];
      }
    }

    for (final id in event.userModel.matches) {
      final matchingMedia = mediaMap[id];
      if (matchingMedia == null || matchingMedia.isEmpty) {
        continue;
      }
      state.otherList.add(OtherStoryModel(
          userName: matchingMedia[0].userName,
          userImage: matchingMedia[0].userImage,
          list: matchingMedia));
    }
    emit(state.copyWith(isLoading: false));
    add(GetStory(context: event.context));
  }
}
