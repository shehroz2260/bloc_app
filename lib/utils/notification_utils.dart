import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class NotificationUtils {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? sub;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static late BuildContext _context;

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  static Future<dynamic> myBackgroundMessageHandler(dynamic message) async {
    await Firebase.initializeApp();

    return Future<void>.value();
  }

  static Future<void> init() async {
    await _firebaseMessaging.getAPNSToken();

    try {
      await Permission.notification.request().isGranted;
    } catch (e) {
      showOkAlertDialog(
          context: _context, message: e.toString(), title: "Error");
    }
    await initLocalNotifications();
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: false, badge: false, sound: false);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message1) {});
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification notification = message!.notification!;

      localNotification(notification.title ?? "", notification.body ?? "", "");
    });
  }

  static Future onSelectNotification(String? payload) async {}

  //**************************************************
  static Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: myBackgroundMessageHandler,
        onDidReceiveNotificationResponse: myBackgroundMessageHandler);
  }

  //**************************************************
  static Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
      context: _context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(body ?? ""),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  //**************************************************
  static Future<void> localNotification(
      String title, String body, String payload) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1',
      title,
      importance: Importance.max,
      priority: Priority.low,
      showWhen: false,
      styleInformation: const BigTextStyleInformation(''),
    );
    DarwinNotificationDetails iosPlatformChannelSpecifics =
        const DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  static Future<void> fcmSubscribe(BuildContext context) async {
    // sub = FirebaseFirestore.instance
    //     .collection(UserModel.tableName)
    //     .where("id", isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
    //     .snapshots()
    //     .listen((event) async {
    //   if (event.docs.isNotEmpty) {
    //     final model = UserModel.fromMap(event.docs[0].data());
    //   }
    // });
    // topic = topic ?? (FirebaseAuth.instance.currentUser?.uid ?? "");

    // log("subscribed $topic");
    // if (topic.isNotEmpty)
    //   await _firebaseMessaging.subscribeToTopic(topic).then((value) {});
    // log("subscribed");

    await _firebaseMessaging.getToken().then((val) {
      var user = context.read<UserBaseBloc>().state.userData;
      user = user.copyWith(fcmToken: val);
      context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
      NetworkService.updateUser(user);
    });
  }

  static Future<void> cancelSub() async {
    await sub?.cancel();
  }

  static Future<void> fcmUnSubscribe([String? topic]) async {
    topic = topic ?? (FirebaseAuth.instance.currentUser?.uid ?? "");
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  // static Debouncer deBouncer =
  //     Debouncer(delay: const Duration(milliseconds: 1000));
}
