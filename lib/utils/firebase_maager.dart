import 'dart:convert';

import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/utils/notification_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class FirebaseManager {
  static Future<void> initFirebaseOnPhone() async {
    await Firebase.initializeApp();
  }

  static Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessage.listen(handleMessage);
    // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static void handleMessage(RemoteMessage message) async {
    try {
      final chatsProvider = navigatorKey.currentContext!.read<ChatProvider>();
      RemoteNotification? notification = message.notification;
      final android = message.notification?.android;
      String notificationTitle = message.notification?.title ?? '';
      final notificationData = message.data;

      if (notification != null) {
        print(notificationData);
        print(
            'notification type type : ${notificationData['type'].runtimeType}');
        print(
            'notification data type : ${notificationData['data'].runtimeType}');
        switch (notificationData['type']) {
          case 'chat':
          // if (notificationData['data']['room']['_id'] == chatsProvider.selectedRoom?.id ||
          //     notificationData['data']['user']['_id'] == chatsProvider.auth?.myUser?.id) {
          //   break;
          // }
            NotificationController.createNewChatNotification(
                message.notification, jsonDecode(notificationData['data']));
            // final roomIndex = chatsProvider.rooms
            //     .indexWhere((element) => element.id == chat.room);
            //
            // if(roomIndex != -1){
            // }

            break;
        }
        // if (android != null) {
        //   // NotificationController.createNewChatNotification(
        //   //     message.notification, message.data['message']);
        // }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<String?> firebaseToken({String? validKey}) async =>
      await FirebaseMessaging.instance.getToken(vapidKey: validKey);

  static Future<void> initFirebaseOnWeb() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyC7lfF_K5-Wktm6DSv5ZoNk18F1MvVpQAI',
          appId: '1:69437946182:web:3ca0be4cb3f2caa0284d47',
          messagingSenderId: '69437946182',
          storageBucket: "babakcode-chat.appspot.com",
          authDomain: "babakcode-chat.firebaseapp.com",
          measurementId: "measurementId",
          projectId: 'babakcode-chat'),
    );
  }
}
