// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';

// class FCMService {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;

//   // Future<String?> initFCM() async {
//   //   try {
//   //     // 1. Request notification permissions (especially needed on iOS and Web)
//   //     await _messaging.requestPermission();

//   //     // 2. Get the device FCM token
//   //     String? token = await _messaging.getToken();

//   //     if (kDebugMode) {
//   //       print("🔥 FCM Token: $token");
//   //     }

//   //     // 3. Handle token refresh
//   //     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//   //       if (kDebugMode) {
//   //         print("🔁 FCM Token refreshed: $newToken");
//   //       }
//   //       // TODO: Update token in Firebase if needed
//   //     });

//   //     return token;
//   //   } catch (e) {
//   //     if (kDebugMode) {
//   //       print("❌ Error getting FCM token: $e");
//   //     }
//   //     return null;
//   //   }
//   // }
//   Future<String?> initFCM() async {
//     try {
//       // 🔒 Request notification permission ONLY for mobile
//       if (defaultTargetPlatform == TargetPlatform.iOS ||
//           defaultTargetPlatform == TargetPlatform.android) {
//         await _messaging.requestPermission(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//       }

//       // 📱 Get the device FCM token
//       String? token = await _messaging.getToken();

//       if (kDebugMode) {
//         print("🔥 FCM Token: $token");
//       }

//       // 🔁 Listen for token refresh
//       _messaging.onTokenRefresh.listen((newToken) {
//         if (kDebugMode) {
//           print("🔁 FCM Token refreshed: $newToken");
//         }
//         // TODO: Save new token to server if needed
//       });

//       return token;
//     } catch (e) {
//       if (kDebugMode) {
//         print("❌ Error getting FCM token: $e");
//       }
//       return null;
//     }
//   }
// }
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> subscribeToTopic() async {
  if (!kIsWeb) {
    try {
      await FirebaseMessaging.instance.subscribeToTopic('all_users');
      print("✅ Subscribed to topic 'all_users'");
    } catch (e) {
      print("❌ Error subscribing to topic: $e");
    }
  } else {
    print("ℹ️ Skipped topic subscription on web");
  }
}
