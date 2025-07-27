import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'fcm_service.dart';

class GuestTokenManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FCMService _fcmService = FCMService();

  Future<void> registerGuestToken() async {
    final token = await _fcmService.initFCM();

    if (token != null) {
      final tokenDoc = _firestore.collection('guest_tokens').doc(token);

      await tokenDoc.set({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': defaultTargetPlatform.name,
      });

      print("✅ Token saved to Firestore");
    }
  }
}
