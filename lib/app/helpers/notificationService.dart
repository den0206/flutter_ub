import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  FirebaseMessaging messgge = FirebaseMessaging.instance;

  Future<String> getToken() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await messgge.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }

      NotificationSettings setting = await messgge.getNotificationSettings();
    }

    final token = await messgge.getToken();
    print(token);
  }
}
