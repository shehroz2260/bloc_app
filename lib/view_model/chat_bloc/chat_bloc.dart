import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_with_bloc/model/thread_model.dart';
import 'package:chat_with_bloc/repos/chat_repo.dart';
import 'package:chat_with_bloc/services/firebase_services_storage.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/custom_image_picker.dart';
import 'package:chat_with_bloc/utils/media_type.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_with_bloc/utils/app_funcs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../model/char_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'package:http/http.dart' as http;
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  DocumentSnapshot? lastDocument;
  Timer? _timer;
  ThreadModel? listenThread;
    bool isRecordingCompleted = false;
  static late RecorderController recorderController;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? threadSnapShot;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? messagesSnapShot;
  ChatBloc() : super(ChatState(isFirstMsg: true,text: "", messageList: [],limit: 20,isLoading: false,messageSending: false,isRecording: false,duration: Duration.zero)) {
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
    on<ChatListenerStream>(_onChatListenerStream);
  }
  //////////////////////////////////////////////////// callabel in view///////////////////////////////////////////////////////
  _onChatLoad(LoadChat event, Emitter<ChatState>emit)async{
    if (state.limit < 20) {
      return;
    }
    emit(state.copyWith(isLoading: true));
     Query<Map<String, dynamic>> snapShotQuery;
    snapShotQuery = ChatRepo.ref(event.thradId)
        .limit(20);
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
      limit: messagesLIst.length,
      messageList: state.messageList,
      isLoading: false
    ));
    add(ChatListener(thradId: event.thradId));
  }

  _onListenThread(OnListenThread event , Emitter<ChatState>emit)async{
     threadSnapShot  =  FirebaseFirestore.instance
        .collection(ThreadModel.tableName)
        .doc(event.threadModel.threadId)
        .snapshots().listen((value){
          listenThread = ThreadModel.fromMap(value.data() as Map<String , dynamic>);
          if(listenThread == null) return;
          listenThread!.readMessage();
        });
  }

_onSendMessage(SendMessage event , Emitter<ChatState>emit)async{
  emit(state.copyWith(messageSending: true));
  String? url ;
  String? thumbUrl ;
if(MediaType.type == MediaType.audio && state.audioUrl != null){
url = await FirebaseStorageService().uploadImage("Chat/Audio/${AppFuncs.generateRandomString(10)}", state.audioUrl??"");
}
if(MediaType.type == MediaType.image && state.pickFile != null){
url = await FirebaseStorageService().uploadImage("Chat/Audio/${AppFuncs.generateRandomString(10)}", state.pickFile?.path??"");
}
if(MediaType.type == MediaType.video && state.pickFile != null && state.thumbnail != null){
url = await FirebaseStorageService().uploadImage("Chat/Video/${AppFuncs.generateRandomString(10)}", state.pickFile?.path??"");
thumbUrl = await FirebaseStorageService().uploadImage("Chat/thumbnail/${AppFuncs.generateRandomString(10)}", state.thumbnail?.path??"");
}
  ThreadModel threadModel = ThreadModel(lastMessage: event.textEditingController.text.isNotEmpty? event.textEditingController.text: MediaType.type == MediaType.image?"New Image":MediaType.type == MediaType.video? "New video": MediaType.type == MediaType.audio ? "Voice": MediaType.type == MediaType.file? "New document":""  , activeUserList: [], lastMessageTime: DateTime.now(), participantUserList: listenThread?.participantUserList??[], senderId: event.context.read<UserBaseBloc>().state.userData.uid, messageCount: 0, threadId: event.threadId, messageDelete: [], isPending: false, isBlocked: false);
var thradJsom = threadModel.toMap();
// thradJsom["senderId"] = FirebaseAuth.instance.currentUser?.uid??"";
if((listenThread?.senderId??"") != (FirebaseAuth.instance.currentUser?.uid??"")){
  thradJsom["messageCount"] = 1;
}else{
  thradJsom["messageCount"] = FieldValue.increment(1);
}

  ChatModel model  = ChatModel(id: AppFuncs.generateRandomString(15), threadId: event.threadId, message: event.textEditingController.text, messageTime: DateTime.now(), senderId: event.context.read<UserBaseBloc>().state.userData.uid, isRead: false,media: (url??"").isEmpty?null: MediaModel(type: MediaType.type, id: AppFuncs.generateRandomString(15), url: url??"", createdAt: DateTime.now(), name: "",thumbnail: thumbUrl));
  
  if(event.isForVc){
    model = model.copyWith(media: MediaModel(type: 5, id: AppFuncs.generateRandomString(15), url: "url", createdAt: DateTime.now(), name: ""));
  }
  try{
    await FirebaseFirestore.instance.collection(ThreadModel.tableName).doc(event.threadId).set(thradJsom,SetOptions(merge: true));
await FirebaseFirestore.instance.collection(ThreadModel.tableName).doc(event.threadId).collection(ChatModel.tableName).doc(model.id).set(model.toMap());
event.textEditingController.clear();
MediaType.type = 0;
emit(state.copyWith(messageSending: false, audioUrl: null,
  pickFile: null,
  thumbnail: null,));
  } on FirebaseException catch (e){
emit(state.copyWith(messageSending: false));
showOkAlertDialog(context: event.context,message: e.message,title: "Error");
  }
}
_onTextFieldChange(OnChangeTextField event ,Emitter<ChatState>emit)async{
emit(state.copyWith(text: event.text));
}

/////////////////////////////////////////// start recording  ///////////////////////////////////////////////////////////////////
_onStartorStopRecording(StartOrStopRecording event, Emitter<ChatState>emit)async{
 if (!await requestMicrophonePermission(event.context)) return;
 emit(state.copyWith(audioUrl: null));
  try {
      if (state.isRecording) {
        recorderController.reset();

      final  audioPath = await recorderController.stop(false);
      emit(state.copyWith(audioUrl: audioPath));
        if (audioPath != null) {
          isRecordingCompleted = true;
          MediaType.type = MediaType.audio;
          _timer?.cancel();
        const  duration = Duration.zero;
      emit(state.copyWith(duration: duration));
          add(SendMessage(threadId: event.threadId, context: event.context, textEditingController: TextEditingController()));
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


     _startTimer(StartTimer event, Emitter<ChatState>emit)async {
      await emit.forEach(_updateTime(event), onData: (value){
        return state.copyWith(duration: value.duration);
      });
  }
  
  _onInitializeAudio(InitiaLizeAudioController event , Emitter<ChatState>emit){
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }
  ///////////////////////////////////////// callable here ////////////////////////////////////
  Future<File?> generateThumbNail(String path) async {
  final uint8list = await VideoThumbnail.thumbnailData(
    video: path,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 390,
    quality: 60,
  );
  final directory = await getTemporaryDirectory();
  final pathOfImage =
      await File('${directory.path}/${DateTime.now().toIso8601String()}.jpeg')
          .create();

  if (uint8list == null) return null;
  File filed = await pathOfImage.writeAsBytes(uint8list);
  return filed;
}

  Stream<ChatState> _updateTime(StartTimer event) async* {
  _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    final duration = Duration(seconds: timer.tick);
    add(UpdateTimer(duration: duration));
  });
}

StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subs;
  Stream<ChatState> _chatListenerStream(ChatListener event) async* {
   subs = ChatRepo.ref(event.thradId).limit(1).snapshots().listen((value){
     if (value.docs.isEmpty) return ;
            var chat = ChatModel.fromMap(value.docs[0].data());
 if(state.messageList.where((e)=> e.id == chat.id).isNotEmpty) return;
 add(ChatListenerStream(model: chat));
  });
}
_onChatListenerStream(ChatListenerStream event , Emitter<ChatState>emit){
  state.messageList.insert(0, event.model);
  emit(state.copyWith(messageList: state.messageList));
}
 _onUpdateTimer(UpdateTimer timer,Emitter<ChatState>emit ){
    final duration  = timer.duration;
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
   _messageListener(ChatListener event , Emitter<ChatState>emit)async{
  await  emit.forEach(
     _chatListenerStream(event), onData: (value){
        return  state.copyWith(messageList: value.messageList);
        });
  }

  _pickFiles(PickFileEvent event, Emitter<ChatState>emit)async {
  bool isVideo = false;
   await showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: event.context, builder: (_){
      return Container(
        height: 200,
        width: MediaQuery.of(event.context).size.width,
        decoration: const BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))

        ),
        padding: const EdgeInsets.only(left: 20),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async{
                Go.back(event.context);
                 MediaType.type = MediaType.image;
                 isVideo  = false;
              },
              child: const Row(
                children: [
                  Icon(Icons.image,size: 60),
                  SizedBox(width: 10),
                 Text("Images",style: TextStyle(fontSize: 40),)
                ],
              ),
            ),
            const SizedBox(height: 10),
             GestureDetector(
              onTap: () async{
                Go.back(event.context);
                MediaType.type = MediaType.video;
                isVideo = true;
              },
               child: const Row(
                children: [
                  Icon(Icons.video_camera_back_outlined,size: 60),
                  SizedBox(width: 10),
                 Text("Video",style: TextStyle(fontSize: 40))
                ],
                           ),
             ),
          ],
        ),
      );
    });

    if(isVideo){
         final file =  await kVideoPicker(context: event.context);
               if(file != null){
                emit(state.copyWith(pickFile: file));
                 final thumbnail = await generateThumbNail(file.path);
                emit(state.copyWith( thumbnail: thumbnail));
               }
    }else{
  final file =  await kImagePicker(context: event.context);
               if(file != null){
                emit(state.copyWith(pickFile: file));
               }
    }
  }
  _clearData(ClearData event , Emitter<ChatState>emit)async{
    lastDocument = null;
    await subs?.cancel();
    emit(state.copyWith(limit: 20,messageList: [],audioUrl: "",duration: Duration.zero,isLoading: false,isRecording: false,messageSending: false,pickFile: null,text: "",thumbnail: null));
    await threadSnapShot?.cancel();
  }

  _downloadAndSaveMedia(DownloadMedia event , Emitter<ChatState>emit)async{

             await Permission.storage.request();
        final photoStatus  = await Permission.phone.request();
        final videoStatus  = await Permission.videos.request();
        final medialibrary = await Permission.mediaLibrary.request();
    if (!medialibrary.isGranted) {
          log("^^^^^^^^^^^^^^^^^^storage$medialibrary");
          log("^^^^^^^^^^^^^^^^^^photo$photoStatus");
          log("^^^^^^^^^^^^^^^^^^video$videoStatus");

      return;
    }
     try {
      final response = await http.get(Uri.parse(event.chat.media?.url??""));
      if (response.statusCode == 200) {
        if ((event.chat.media?.type??0) == MediaType.image) {
          final result = await ImageGallerySaver.saveImage(
            response.bodyBytes,
            quality: 100,
          );
          if (result != null && result['isSuccess']) {
            showOkAlertDialog(context: event.context,message: "Image save to gallery",title: "Download media");
          } else {
            showOkAlertDialog(context: event.context,message: "Failed to save image",title: "Download media");

          }
        } else if ((event.chat.media?.type??0) == MediaType.video) {
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          final result = await ImageGallerySaver.saveFile(filePath);
          if (result != null && result['isSuccess']) {
            showOkAlertDialog(context: event.context,message: "Video saved to gallery",title: "Download media");

          } else {
            showOkAlertDialog(context: event.context,message: "Failed to save video",title: "Download media");

          }
        }
      } else {
            showOkAlertDialog(context: event.context,message: "Failed to download media",title: "Download media");

      }
    } catch (e) {
            showOkAlertDialog(context: event.context,message: e.toString(),title: "Download media");

    }
  }
}
