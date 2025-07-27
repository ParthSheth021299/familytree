// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class NotificationHandler {
//   static final FlutterLocalNotificationsPlugin
//   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   static Future<void> initialize(BuildContext context) async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // App is in foreground – manually show notification
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;

//       if (notification != null && android != null) {
//         _flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               'default_channel_id',
//               'Default Channel',
//               channelDescription: 'General notifications',
//               importance: Importance.max,
//               priority: Priority.high,
//               playSound: true,
//               icon: '@mipmap/ic_launcher',
//             ),
//           ),
//         );
//       }
//     });
//   }
// }
