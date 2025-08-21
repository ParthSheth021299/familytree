// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<void> sendNotificationToAllUsers({
//   required String title,
//   required String body,
// }) async {
//   const String serverKey =
//       '57c374685c836dca971dd90d54c75813db0aeb18'; // Replace this

//   final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'key=$serverKey',
//   };

//   final payload = {
//     "to": "/topics/all_users",
//     "notification": {"title": title, "body": body, "sound": "default"},
//     "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "status": "done"},
//     "time_to_live": 1, // TTL set to 1 second
//   };

//   final response = await http.post(
//     url,
//     headers: headers,
//     body: jsonEncode(payload),
//   );

//   if (response.statusCode == 200) {
//     print('✅ Notification sent successfully!');
//   } else {
//     print('❌ Failed to send notification: ${response.body}');
//   }
// }
import 'dart:convert';

import 'package:http/http.dart' as http;

// Future<void> sendNotificationToAndroid() async {
//   const String restApiKey =
//       'os_v2_app_mieu27lrvzc3hg7zqwficxegwix4j5bbu2fekt4cyaekwwmmcaaehaz33j64tz3mltyly2f74ug2keegfnzo5hhogvkrjseophf6eha';
//   const String appId = '62094d7d-71ae-45b3-9bf9-858a815c86b2';

//   final url = Uri.parse('https://onesignal.com/api/v1/notifications');
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Basic $restApiKey',
//   };
//   final body = {
//     'app_id': appId,
//     'included_segments': ['All'],
//     'filters': [
//       {'field': 'device_type', 'relation': '=', 'value': 1},
//     ],
//     'headings': {'en': 'Android Only'},
//     'contents': {'en': 'Sent from Flutter Admin'},
//   };

//   await http.post(url, headers: headers, body: jsonEncode(body));
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

// Future<void> sendNotificationToAndroid({
//   required String title,
//   required String description,
//   required String date,
// }) async {
//   const String restApiKey =
//       // 'os_v2_app_mieu27lrvzc3hg7zqwficxegwix4j5bbu2fekt4cyaekwwmmcaaehaz33j64tz3mltyly2f74ug2keegfnzo5hhogvkrjseophf6eha';
//       'x4j5bbu2fekt4cyaekwwmmcaa';
//   const String appId = '62094d7d-71ae-45b3-9bf9-858a815c86b2';

//   final url = Uri.parse('https://onesignal.com/api/v1/notifications');
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Basic $restApiKey',
//   };
//   final id = await OneSignal.User.getOnesignalId();
//   print("ID ${id}");

//   final body = {
//     'app_id': appId,
//     'included_segments': ['All'],

//     'headings': {'en': title},
//     'contents': {'en': '$description\n📅 $date'},
//     'data': {
//       'click_action':
//           'FLUTTER_NOTIFICATION_CLICK', // optional if using Firebase-style click
//     },
//   };

//   final response = await http.post(
//     url,
//     headers: headers,
//     body: jsonEncode(body),
//   );

//   if (response.statusCode == 200) {
//     print('✅ Notification sent to Android devices!');
//   } else {
//     print('❌ Failed to send notification: ${response.statusCode}');
//     print('Response body: ${response.body}');
//   }
// }
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<void> sendNotificationToAndroid({
  required String title,
  required String description,
  required String date,
}) async {
  const String restApiKey =
      'os_v2_app_mieu27lrvzc3hg7zqwficxegwjsl75ckpgkueae5zh5rwphz3kmtp6ldql7nui4bieeabcvgykhsthekwqlwenf7kmhjbx7zpuast4y'; // ⚠️ Make sure this is valid and partial key is not expired
  const String appId = '62094d7d-71ae-45b3-9bf9-858a815c86b2';

  final url = Uri.parse('https://onesignal.com/api/v1/notifications');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic $restApiKey',
  };

  final body = {
    'app_id': appId,
    'included_segments': ['All'], // Sends to all users of the app
    'headings': {'en': title},
    'contents': {'en': '$description\n📅 $date'},
    'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
  };

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('✅ Notification sent to Android devices!');
    } else {
      print('❌ Failed to send notification: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('❌ Exception while sending notification: $e');
  }
}
