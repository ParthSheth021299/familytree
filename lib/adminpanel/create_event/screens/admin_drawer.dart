import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateEvent extends StatelessWidget {
  const CreateEvent({super.key});

  Future<void> sendPushNotification() async {
    final serverKey =
        '556254409740	'; // Get this from Firebase Console -> Project Settings -> Cloud Messaging tab

    final tokenSnapshot = await FirebaseFirestore.instance
        .collection('guest_tokens')
        .get();
    final tokens = tokenSnapshot.docs.map((doc) => doc['token']).toList();

    for (String token in tokens) {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'to': token,
          'notification': {
            'title': 'Family Event Reminder',
            'body': 'There is an upcoming family event!',
          },
          'priority': 'high',
        }),
      );
    }

    print('✅ Notification sent to all guest tokens');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: Column(
        children: [
          SizedBox(height: 50),
          TextField(decoration: InputDecoration(labelText: 'Event Title')),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              sendPushNotification();
            },
            child: Text('Send Reminder'),
          ),
        ],
      ),
    );
  }
}
