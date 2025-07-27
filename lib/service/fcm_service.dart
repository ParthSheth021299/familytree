import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> initFCM() async {
    try {
      // 1. Request notification permissions (especially needed on iOS and Web)
      await _messaging.requestPermission();

      // 2. Get the device FCM token
      String? token = await _messaging.getToken();

      if (kDebugMode) {
        print("🔥 FCM Token: $token");
      }

      // 3. Handle token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        if (kDebugMode) {
          print("🔁 FCM Token refreshed: $newToken");
        }
        // TODO: Update token in Firebase if needed
      });

      return token;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error getting FCM token: $e");
      }
      return null;
    }
  }
}
