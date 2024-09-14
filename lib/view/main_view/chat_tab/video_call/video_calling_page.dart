import 'package:chat_with_bloc/model/char_model.dart';
import 'package:chat_with_bloc/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../../src/app_colors.dart';
import '../../../../view_model/chat_bloc/chat_bloc.dart';
import '../../../../view_model/chat_bloc/chat_event.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class Signaling {
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;

  Future<String> createRoom(RTCVideoRenderer remoteRenderer) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc();


    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // Code for collecting ICE candidates below
    var callerCandidatesCollection = roomRef.collection('callerCandidates');

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      callerCandidatesCollection.add(candidate.toMap());
    };
    
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);

    Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};

    await roomRef.set(roomWithOffer);
    var roomId = roomRef.id;
    currentRoomText = 'Current room is $roomId - You are the caller!';
    // Created a Room

    peerConnection?.onTrack = (RTCTrackEvent event) {

      event.streams[0].getTracks().forEach((track) {
        remoteStream?.addTrack(track);
      });
    };

    // Listening for remote session description below
    roomRef.snapshots().listen((snapshot) async {

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (peerConnection?.getRemoteDescription() != null &&
          data['answer'] != null) {
        var answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );

        await peerConnection?.setRemoteDescription(answer);
        
      }
    });
    // Listening for remote session description above

    // Listen for remote Ice candidates below
    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      }
    });
    // Listen for remote ICE candidates above

    return roomId;
  }

  Future<void> joinRoom(String roomId, RTCVideoRenderer remoteVideo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc(roomId);
    var roomSnapshot = await roomRef.get();

    if (roomSnapshot.exists) {
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          return;
        }
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidate above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        event.streams[0].getTracks().forEach((track) {
          remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      var data = roomSnapshot.data() as Map<String, dynamic>;
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection!.createAnswer();

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        for (var document in snapshot.docChanges) {
          var data = document.doc.data() as Map<String, dynamic>;
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      });
    }
  }

  Future<void> openUserMedia(
    RTCVideoRenderer localVideo,
    RTCVideoRenderer remoteVideo,
  ) async {
    var stream = await navigator.mediaDevices
        .getUserMedia({
  'video': {
    'mandatory': {
      'minWidth': '640',
      'minHeight': '480',
      'minFrameRate': '30',
    },
    'facingMode': 'user',
    'optional': [],
  },
  'audio': true,
});

    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  Future<void> hangUp(RTCVideoRenderer localVideo, String roomID, String threadID) async {
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    for (var track in tracks) {
      track.stop();
    }

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();
    // if (roomId != null) {
      var db = FirebaseFirestore.instance;
      var roomRef = db.collection('rooms').doc(roomID);
      var calleeCandidates = await roomRef.collection('calleeCandidates').get();
      for (var document in calleeCandidates.docs) {
        document.reference.delete();
      }

      var callerCandidates = await roomRef.collection('callerCandidates').get();
      for (var document in callerCandidates.docs) {
        document.reference.delete();
      }

      await roomRef.delete();
    // }
   await FirebaseFirestore.instance.collection("thread").doc(threadID).collection(ChatModel.tableName).where("message",isEqualTo: roomID).get().then((val)async{
      await val.docs[0].reference.delete();
    });

    localStream!.dispose();
    remoteStream?.dispose();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }
}




class MyHomePage extends StatefulWidget {
  final String threadId;
  final bool isCreateRoom;
  final String roomId;
  final UserModel userModel;
  const MyHomePage({super.key, required this.threadId, required this.isCreateRoom, required this.roomId, required this.userModel});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
oninitEvent();
    super.initState();
  }
void oninitEvent()async{
      _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
     
      setState(() {
         _remoteRenderer.srcObject = stream;
      _remoteRenderer.srcObject = signaling.remoteStream;
      });
    });


await signaling.openUserMedia(_localRenderer, _remoteRenderer);


if(widget.isCreateRoom){
   roomId =   await signaling.createRoom(_remoteRenderer);
   textEditingController.text = roomId??"";
   context.read<ChatBloc>().add(SendMessage(threadId: widget.threadId, context: context, textEditingController: TextEditingController(text: roomId),isForVc: true));
 
}else{
    signaling.joinRoom(
                      widget.roomId,
                      _remoteRenderer,
                    );

}
}
  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebRTC"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    signaling.joinRoom(
                    widget.isCreateRoom?  textEditingController.text.trim(): widget.roomId,
                      _remoteRenderer,
                    );
                  },
                  child: const Text("Join room"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    signaling.hangUp(_localRenderer,  widget.isCreateRoom?  textEditingController.text.trim(): widget.roomId,widget.threadId);
                  },
                  child: const Text("Hangup"),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          //  Expanded(
          //    child: Stack(
          //     children: [
          //              SizedBox(
          //     height: double.infinity,
          //     width: double.infinity,
          //     child: _remoteRenderer == RTCVideoRenderer()? AppCacheImage(imageUrl: widget.userModel.profileImage):RTCVideoView(_remoteRenderer),
          //              )
          //     ],
          //              ),
          //  ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(_localRenderer, mirror: true,placeholderBuilder: (context) {
                  return  Container(color: AppColors.blueColor,child: const Text("data"),);
                  },)),
                  Expanded(child: RTCVideoView(_remoteRenderer)),
                ],
              ),
            ),
          ),
          // if(widget.isCreateRoom)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Join the following Room: "),
                Flexible(
                  child: TextFormField(
                    controller: textEditingController,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 8)
        ],
      ),
    );
  }
}


enum CallStatus {calling, ringing, accepted}
// class VideoCallingPage extends StatefulWidget {
//   final UserModel user;
//   final CallStatus? callStatus;
//   final String? roomId;
//   const VideoCallingPage({super.key, required this.user, this.callStatus, this.roomId});

//   @override
//   State<VideoCallingPage> createState() => _VideoCallingPageState();
// }

// class _VideoCallingPageState extends State<VideoCallingPage> {
//    late RTCPeerConnection _peerConnection;
//   late MediaStream _localStream;
//   final _localRenderer = RTCVideoRenderer();
//   final _remoteRenderer = RTCVideoRenderer();
//   late WebSocketChannel _channel;

//   Signaling signaling = Signaling();
//   CallStatus? status;
//   String? roomId;
//   final channel = WebSocketChannel.connect(Uri.parse('wss://your-signaling-server.example.com'));
//   final RTCVideoRenderer _localRendering = RTCVideoRenderer();
//   final RTCVideoRenderer _remoteRendering = RTCVideoRenderer();
// initiliazeWebRtc()async{
//    _localRendering.initialize();
//    _remoteRendering.initialize();

// signaling.onAddRemoteStream = ((stream){
//   _remoteRenderer.srcObject  = stream;
//   setState(() {  });

// }); 

// signaling.openUserMedia(_localRenderer, _remoteRenderer);
// if(status == CallStatus.calling){
//   roomId = await signaling.createRoom(_remoteRenderer);
// }else{
//   roomId = widget.roomId;
//   signaling.joinRoom(roomId??"", _remoteRenderer);
// }
// }

//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     _localStream.dispose();
//     _peerConnection.close();
//     _channel.sink.close();
//     super.dispose();
//   }

// @override
//   void initState() {
//     status = widget.callStatus ?? CallStatus.calling;
//     initiliazeWebRtc();
//     _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
//     _channel.sink.add(jsonEncode({'type': 'join', 'roomId': widget.roomId}));
   
//      log('^^^^^^^^^^^^^^^^^^^^^^^$_localRenderer');
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Call'),
//       ),
//       body: Column(
//         children: [
       
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(widget.user.profileImage),
//                     radius: 30,
//                   ),
//                   const SizedBox(width: 10),
//                   Text(widget.user.name),
//                 ],
//               ),
//             ),
//           Expanded(
//             child: Container(
//               color: Colors.red,
//               child: RTCVideoView(
//                 _localRenderer,
//                 mirror: true,
//                 objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//               ),
//             ),
//           ),
//           Expanded(
//             child: RTCVideoView(
//               _remoteRenderer,
//               objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
