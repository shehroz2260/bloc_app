import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_with_bloc/model/thread_model.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/services/firebase_services_storage.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/custom_image_picker.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/utils/media_type.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_with_bloc/utils/app_funcs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../model/char_model.dart';
import '../../services/notification_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  DocumentSnapshot? lastDocument;
  Timer? _timer;
  static ThreadModel? listenThread;
  static UserModel? listenUser;
  bool isRecordingCompleted = false;
  static late RecorderController recorderController;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? threadSnapShot;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? messagesSnapShot;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userSnapShot;
  ChatBloc()
      : super(ChatState(
            isFirstMsg: true,
            text: "",
            messageList: [],
            limit: 20,
            isLoading: false,
            messageSending: false,
            isRecording: false,
            duration: Duration.zero)) {
    on<LoadChat>(_onChatLoad);
    on<OnChangeTextField>(_onTextFieldChange);
    on<ChatListener>(_messageListener);
    on<SendMessage>(_onSendMessage);
    on<DownloadMedia>(_downloadAndSaveMedia);
    on<StartTimer>(_startTimer);
    on<OnListenThread>(_onListenThread);
    on<InitiaLizeAudioController>(_onInitializeAudio);
    on<StartOrStopRecording>(_onStartorStopRecording);
    on<UpdateTimer>(_onUpdateTimer);
    on<PickFileEvent>(_pickFiles);
    on<ClearData>(_clearData);
    on<ListenUserEvent>(_listenUserEvent);
    on<OpenOptions>(_openOptions);
    on<ClearChat>(_clearChat);
    on<ChatListenerStream>(_onChatListenerStream);
  }
  //////////////////////////////////////////////////// callabel in view///////////////////////////////////////////////////////
  _onChatLoad(LoadChat event, Emitter<ChatState> emit) async {
    if (state.limit < 20) {
      return;
    }
    if (state.isFirstMsg) {
      emit(state.copyWith(isLoading: true, isFirstMsg: false));
    }
    Query<Map<String, dynamic>> snapShotQuery;
    final ref = FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .doc(event.thradId)
        .collection(ChatModel.tableName)
        .orderBy("messageTime", descending: true)
        .limit(20);
    final deletedAt = event.model.messageDelete
        .where((e) => e.id == (FirebaseAuth.instance.currentUser?.uid ?? ""))
        .toList();
    snapShotQuery = deletedAt.isEmpty
        ? ref
        : ref.where("messageTime",
            isGreaterThan: Timestamp.fromDate(deletedAt[0].deleteAt));
    if (lastDocument != null) {
      snapShotQuery = snapShotQuery.startAfterDocument(lastDocument!);
    }
    var snapShot = await snapShotQuery.get();

    var messagesLIst = snapShot.docs.map((e) {
      lastDocument = e;
      return ChatModel.fromMap(e.data());
    }).toList();

    state.messageList.addAll(messagesLIst);
    emit(state.copyWith(
      isLoading: false,
      limit: messagesLIst.length,
      messageList: state.messageList,
    ));
    add(ChatListener(thradId: event.thradId, model: event.model));
  }

  _listenUserEvent(ListenUserEvent event, Emitter<ChatState> emit) {
    userSnapShot = FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(event.id)
        .snapshots()
        .listen((value) {
      if (value.exists) {
        listenUser = UserModel.fromMap(value.data()!);
      }
    });
  }

  _onListenThread(OnListenThread event, Emitter<ChatState> emit) async {
    threadSnapShot = FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .doc(event.threadModel.threadId)
        .snapshots()
        .listen((value) {
      listenThread = ThreadModel.fromMap(value.data() as Map<String, dynamic>);
      if (listenThread == null) return;
      listenThread!.readMessage();
    });
  }

  _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    final cUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if ((listenThread?.blockUserList ?? []).contains(cUserId)) {
      var res = await showOkCancelAlertDialog(
          context: event.context,
          message: "Please Unblock to send the message",
          title: "Blocked",
          okLabel: "Unblock");
      if (res == OkCancelResult.cancel) return;
      NetworkService.unblockUser(listenThread!);
    }

    if ((listenThread?.blockUserList ?? [])
        .contains(event.threadModel.userDetail?.uid ?? "")) {
      showOkAlertDialog(
          context: event.context,
          message:
              "You are block by ${event.threadModel.userDetail?.firstName ?? ""}");
      return;
    }
    emit(state.copyWith(messageSending: true));

    String? url;
    String? thumbUrl;
    if (MediaType.type == MediaType.audio && state.audioUrl != null) {
      url = await FirebaseStorageService().uploadImage(
          "Chat/Audio/${AppFuncs.generateRandomString(10)}",
          state.audioUrl ?? "");
    }
    if (MediaType.type == MediaType.image && state.pickFile != null) {
      url = await FirebaseStorageService().uploadImage(
          "Chat/Audio/${AppFuncs.generateRandomString(10)}",
          state.pickFile?.path ?? "");
    }
    if (MediaType.type == MediaType.video &&
        state.pickFile != null &&
        state.thumbnail != null) {
      url = await FirebaseStorageService().uploadImage(
          "Chat/Video/${AppFuncs.generateRandomString(10)}",
          state.pickFile?.path ?? "");
      thumbUrl = await FirebaseStorageService().uploadImage(
          "Chat/thumbnail/${AppFuncs.generateRandomString(10)}",
          state.thumbnail?.path ?? "");
    }
    ThreadModel threadModel = ThreadModel(
        lastMessage: event.textEditingController.text.isNotEmpty
            ? event.textEditingController.text
            : MediaType.type == MediaType.image
                ? "New Image"
                : MediaType.type == MediaType.video
                    ? "New video"
                    : MediaType.type == MediaType.audio
                        ? "Voice"
                        : MediaType.type == MediaType.file
                            ? "New document"
                            : "",
        activeUserList: [],
        lastMessageTime: DateTime.now(),
        participantUserList: listenThread?.participantUserList ?? [],
        senderId: event.context.read<UserBaseBloc>().state.userData.uid,
        messageCount: 0,
        threadId: event.threadId,
        messageDelete: listenThread?.messageDelete ?? [],
        isPending: false,
        isAdmin: listenThread?.isAdmin ?? false,
        isBlocked: false,
        blockUserList: []);
    var thradJsom = threadModel.toMap();
// thradJsom["senderId"] = FirebaseAuth.instance.currentUser?.uid??"";
    if ((listenThread?.senderId ?? "") !=
        (FirebaseAuth.instance.currentUser?.uid ?? "")) {
      thradJsom["messageCount"] = 1;
    } else {
      thradJsom["messageCount"] = FieldValue.increment(1);
    }

    ChatModel model = ChatModel(
        id: AppFuncs.generateRandomString(15),
        threadId: event.threadId,
        message: event.textEditingController.text,
        messageTime: DateTime.now(),
        senderId: FirebaseAuth.instance.currentUser?.uid ?? "",
        isRead: false,
        media: (url ?? "").isEmpty
            ? null
            : MediaModel(
                type: MediaType.type,
                id: AppFuncs.generateRandomString(15),
                url: url ?? "",
                createdAt: DateTime.now(),
                name: "",
                thumbnail: thumbUrl));

    if (event.isForVc) {
      model = model.copyWith(
          media: MediaModel(
              type: 5,
              id: AppFuncs.generateRandomString(15),
              url: "url",
              createdAt: DateTime.now(),
              name: ""));
    }
    try {
      await FirebaseFirestore.instance
          .collection(ThreadModel.tableName)
          .doc(event.threadId)
          .set(thradJsom, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection(ThreadModel.tableName)
          .doc(event.threadId)
          .collection(ChatModel.tableName)
          .doc(model.id)
          .set(model.toMap())
          .then((value) {
        if (listenUser?.isOnNotification ?? false) {
          NotificationService().sendNotification(
              titleNotification:
                  event.context.read<UserBaseBloc>().state.userData.firstName,
              bodyNotification: model.media != null
                  ? model.media!.type == MediaType.video
                      ? "Sent you a video"
                      : model.media!.type == MediaType.image
                          ? "Sent you a photo"
                          : model.media!.type == MediaType.audio
                              ? "Sent you a audio"
                              : "Sent you a file"
                  : event.textEditingController.text,
              type: model.media != null ? "media" : "chat",
              fcmToken: listenUser?.fcmToken ?? "");
        }
      });
      event.textEditingController.clear();
      MediaType.type = 0;
      emit(state.copyWith(
        messageSending: false,
        audioUrl: null,
        pickFile: File(""),
        thumbnail: File(""),
      ));
    } on FirebaseException catch (e) {
      emit(state.copyWith(messageSending: false));
      showOkAlertDialog(
          context: event.context, message: e.message, title: "Error");
    }
  }

  _onTextFieldChange(OnChangeTextField event, Emitter<ChatState> emit) async {
    emit(state.copyWith(text: event.text));
  }

/////////////////////////////////////////// start recording  ///////////////////////////////////////////////////////////////////
  _onStartorStopRecording(
      StartOrStopRecording event, Emitter<ChatState> emit) async {
    if (!await requestMicrophonePermission(event.context)) return;
    emit(state.copyWith(audioUrl: null));
    try {
      if (state.isRecording) {
        recorderController.reset();

        final audioPath = await recorderController.stop(false);
        emit(state.copyWith(audioUrl: audioPath));
        if (audioPath != null) {
          isRecordingCompleted = true;
          MediaType.type = MediaType.audio;
          _timer?.cancel();
          const duration = Duration.zero;
          emit(state.copyWith(duration: duration));
          add(SendMessage(
              threadModel: event.model,
              isForVc: false,
              threadId: event.threadId,
              context: event.context,
              textEditingController: TextEditingController()));
        }
      } else {
        await recorderController.record(path: state.audioUrl);
        add(StartTimer());
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      emit(state.copyWith(isRecording: !state.isRecording));
    }
  }

  _startTimer(StartTimer event, Emitter<ChatState> emit) async {
    await emit.forEach(_updateTime(event), onData: (value) {
      return state.copyWith(duration: value.duration);
    });
  }

  _onInitializeAudio(InitiaLizeAudioController event, Emitter<ChatState> emit) {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  ///////////////////////////////////////// callable here ////////////////////////////////////

  Stream<ChatState> _updateTime(StartTimer event) async* {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final duration = Duration(seconds: timer.tick);
      add(UpdateTimer(duration: duration));
    });
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subs;
  Stream<ChatState> _chatListenerStream(ChatListener event) async* {
    var ref = FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .doc(event.thradId)
        .collection(ChatModel.tableName)
        .orderBy("messageTime", descending: true)
        .limit(1);
    final deletedAt = event.model.messageDelete
        .where((e) => e.id == (FirebaseAuth.instance.currentUser?.uid ?? ""))
        .toList();
    subs = (deletedAt.isEmpty
            ? ref
            : ref.where("messageTime",
                isGreaterThanOrEqualTo:
                    Timestamp.fromDate(deletedAt[0].deleteAt)))
        .snapshots()
        .listen((value) {
      if (value.docs.isEmpty) return;
      var chat = ChatModel.fromMap(value.docs[0].data());
      if (state.messageList.where((e) => e.id == chat.id).isNotEmpty) return;
      add(ChatListenerStream(model: chat));
    });
  }

  _onChatListenerStream(ChatListenerStream event, Emitter<ChatState> emit) {
    state.messageList.insert(0, event.model);
    emit(state.copyWith(messageList: state.messageList));
  }

  _onUpdateTimer(UpdateTimer timer, Emitter<ChatState> emit) {
    final duration = timer.duration;
    emit(state.copyWith(duration: duration));
  }

  Future<bool> requestMicrophonePermission(BuildContext context) async {
    PermissionStatus status = await Permission.microphone.request();

    if (status == PermissionStatus.permanentlyDenied) {
      showOkCancelAlertDialog(
              context: context,
              title: "Audio Permission",
              message:
                  "Audio permission is required for this app, Please enable permission from setting.",
              cancelLabel: "Cancel",
              okLabel: "Open setting")
          .then((value) async {
        if (value == OkCancelResult.ok) {
          openAppSettings();
        }
      });
      return false;
    }
    return true;
  }

  _messageListener(ChatListener event, Emitter<ChatState> emit) async {
    await emit.forEach(_chatListenerStream(event), onData: (value) {
      return state.copyWith(messageList: value.messageList);
    });
  }

  _pickFiles(PickFileEvent event, Emitter<ChatState> emit) async {
    bool isVideo = false;
    bool isImage = false;
    await showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: event.context,
        builder: (_) {
          return Container(
            height: 200,
            width: MediaQuery.of(event.context).size.width,
            decoration: BoxDecoration(
                color: AppColors.borderGreyColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    Go.back(event.context);
                    MediaType.type = MediaType.image;
                    isImage = true;
                  },
                  child: Row(
                    children: [
                      Icon(Icons.image, size: 40, color: AppColors.redColor),
                      const SizedBox(width: 10),
                      Text(
                        AppLocalizations.of(event.context)!.image,
                        style: const TextStyle(fontSize: 30),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    Go.back(event.context);
                    MediaType.type = MediaType.video;
                    isVideo = true;
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.video_camera_back_outlined,
                        size: 40,
                        color: AppColors.redColor,
                      ),
                      const SizedBox(width: 10),
                      Text(AppLocalizations.of(event.context)!.video,
                          style: const TextStyle(fontSize: 30))
                    ],
                  ),
                ),
              ],
            ),
          );
        });

    if (isVideo) {
      final file = await kVideoPicker(context: event.context);
      if (file != null) {
        emit(state.copyWith(pickFile: file));
        final thumbnail = await AppFuncs.generateThumbNail(file.path);
        emit(state.copyWith(thumbnail: thumbnail));
      }
    }
    if (isImage) {
      final file = await kImagePicker(context: event.context);
      if (file != null) {
        emit(state.copyWith(pickFile: file));
      }
    }
  }

  _clearData(ClearData event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
        limit: 20,
        messageList: [],
        audioUrl: "",
        duration: Duration.zero,
        isLoading: false,
        isRecording: false,
        messageSending: false,
        pickFile: null,
        text: "",
        thumbnail: null,
        isFirstMsg: true,
        threadModel: null));
    lastDocument = null;
    await threadSnapShot?.cancel();
    await subs?.cancel();
    await userSnapShot?.cancel();
    subs = null;
    threadSnapShot = null;
  }

  _downloadAndSaveMedia(DownloadMedia event, Emitter<ChatState> emit) async {
    await Permission.storage.request();
    final photoStatus = await Permission.phone.request();
    final videoStatus = await Permission.videos.request();
    final medialibrary = await Permission.mediaLibrary.request();
    if (!medialibrary.isGranted) {
      log("^^^^^^^^^^^^^^^^^^storage$medialibrary");
      log("^^^^^^^^^^^^^^^^^^photo$photoStatus");
      log("^^^^^^^^^^^^^^^^^^video$videoStatus");

      return;
    }
    try {
      final response = await http.get(Uri.parse(event.chat.media?.url ?? ""));
      if (response.statusCode == 200) {
        if ((event.chat.media?.type ?? 0) == MediaType.image) {
          // final result = await ImageGallerySaverPlus.saveFile(
          //     File.fromRawPath(response.bodyBytes).path);
          // if (result != null && result['isSuccess']) {
          //   showOkAlertDialog(
          //       context: event.context,
          //       message: "Image save to gallery",
          //       title: "Download media");
          // } else {
          //   showOkAlertDialog(
          //       context: event.context,
          //       message: "Failed to save image",
          //       title: "Download media");
          // }
        } else if ((event.chat.media?.type ?? 0) == MediaType.video) {
          final directory = await getTemporaryDirectory();
          final filePath =
              '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          // final result = await ImageGallerySaver.saveFile(filePath);
          // if (result != null && result['isSuccess']) {
          //   showOkAlertDialog(
          //       context: event.context,
          //       message: "Video saved to gallery",
          //       title: "Download media");
          // } else {
          //   showOkAlertDialog(
          //       context: event.context,
          //       message: "Failed to save video",
          //       title: "Download media");
          // }
        }
      } else {
        showOkAlertDialog(
            context: event.context,
            message: "Failed to download media",
            title: "Download media");
      }
    } catch (e) {
      showOkAlertDialog(
          context: event.context,
          message: e.toString(),
          title: "Download media");
    }
  }

  _clearChat(ClearChat event, Emitter<ChatState> emit) async {
    LoadingDialog.showProgress(event.context);
    await ThreadModel.deleteMessages(listenThread!, event.context);
    emit(state.copyWith(messageList: []));
    if (lastDocument != null) {
      lastDocument = null;
    }
    LoadingDialog.hideProgress(event.context);
  }

  _openOptions(OpenOptions event, Emitter<ChatState> emit) async {
    var result = await showConfirmationDialog(
        context: event.context,
        title: AppLocalizations.of(event.context)!.pleaseSelectOption,
        actions: [
          AlertDialogAction(
              key: "1", label: AppLocalizations.of(event.context)!.clearChat),
          AlertDialogAction(
              key: "2",
              label:
                  "${AppLocalizations.of(event.context)!.report} ${event.userModel.firstName}"),
          AlertDialogAction(
              key: "3",
              label: (listenThread?.blockUserList ?? [])
                      .contains(FirebaseAuth.instance.currentUser?.uid ?? "")
                  ? "${AppLocalizations.of(event.context)!.unBlock} ${event.userModel.firstName}"
                  : "${AppLocalizations.of(event.context)!.block} ${event.userModel.firstName}"),
        ]);
    if (result == null) {
      return;
    }

    if (result == "1") {
      var okCancelRes = await showOkCancelAlertDialog(
          context: event.context,
          message:
              AppLocalizations.of(event.context)!.doyouReallyWanttoclearChat,
          title: AppLocalizations.of(event.context)!.areYouSure);
      if (okCancelRes == OkCancelResult.cancel) return;
      add(ClearChat(context: event.context));
    }
    if (result == "2") {
      var okCanRes = await showOkCancelAlertDialog(
          context: event.context,
          message:
              "${AppLocalizations.of(event.context)!.doyouReallywantToreport} ${event.userModel.firstName}${AppLocalizations.of(event.context)!.thisActionisPermanent}",
          title: AppLocalizations.of(event.context)!.report);
      if (okCanRes == OkCancelResult.cancel) return;
      final options = await NetworkService.reportUser(
          event.userModel, event.context, listenThread);
      if (options.isEmpty) return;
    }
    if (result == "3") {
      var blockRslt = await showOkCancelAlertDialog(
          context: event.context,
          message:
              "${AppLocalizations.of(event.context)!.doyouReallyWanttoblock} ${event.userModel.firstName}",
          title: AppLocalizations.of(event.context)!.areYouSure,
          okLabel: (listenThread?.blockUserList ?? [])
                  .contains(FirebaseAuth.instance.currentUser?.uid ?? "")
              ? AppLocalizations.of(event.context)!.unBlock
              : AppLocalizations.of(event.context)!.block);
      if (blockRslt == OkCancelResult.cancel) return;

      if ((listenThread?.blockUserList ?? [])
          .contains(FirebaseAuth.instance.currentUser?.uid ?? "")) {
        NetworkService.unblockUser(listenThread!);
      } else {
        NetworkService.blockUser(listenThread!);
      }
    }
  }
}
