import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    // Only Android 13+ needs runtime permission
    if (await Permission.notification.isDenied ||
        await Permission.notification.isRestricted) {
      final result = await Permission.notification.request();

      if (result.isGranted) {
        print("✅ Notification permission granted");
      } else {
        print("❌ Notification permission denied");
      }
    } else {
      print("🔔 Notification permission already granted");
    }
  } else if (Platform.isIOS) {
    // iOS FirebaseMessaging handles this
  }
}
