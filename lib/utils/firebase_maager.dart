import 'package:chat_babakcode/utils/notification_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseManager {
  static Future<void> initFirebaseOnPhone() async {
    await Firebase.initializeApp();
    if (kDebugMode) {
      print('------ firebase token --- is : ');
      firebaseToken.then((value) => print(value));
    }
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
      RemoteNotification? notification = message.notification;
      final android = message.notification?.android;
      String notificationTitle = message.notification?.title ?? '';

      if (notification != null) {
        if (android != null) {
          NotificationController.createNewChatNotification(
              message.notification, message.data['message']);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<String?> get firebaseToken async =>
      await FirebaseMessaging.instance.getToken();




}
