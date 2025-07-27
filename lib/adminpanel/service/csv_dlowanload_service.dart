import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_saver/file_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

Future<void> downloadFamilyDataAsCSV() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('family_members')
        .get();

    final List<List<dynamic>> rows = [];

    // Define your headers
    rows.add([
      'Name',
      'Gender',
      'DOB',
      'Phone',
      'Email',
      'Blood Group',
      'Is Married',
      'Is Root',
      'Parent ID',
      'Location',
      'Main Root',
      'Spouse Name',
      'Spouse Email',
      'Spouse Phone',
      'Spouse Blood Group',
      'Spouse Location',
      'Created By',
      'Created At',
      'Updated At',
    ]);

    // Fill in data rows
    for (var doc in snapshot.docs) {
      final data = doc.data();

      rows.add([
        data['name'] ?? '',
        data['gender'] ?? '',
        data['dob'] ?? '',
        data['phone'] ?? '',
        data['email'] ?? '',
        data['bloodGroup'] ?? '',
        data['isMarried'] ?? '',
        data['isRoot'] ?? '',
        data['parentId'] ?? '',
        data['location'] ?? '',
        data['mainRoot'] ?? '',
        data['spouseName'] ?? '',
        data['spouseEmail'] ?? '',
        data['spouseWhatsapp'] ?? '',
        data['spouseBloodGroup'] ?? '',
        data['spouseLocation'] ?? '',
        data['createdBy'] ?? '',
        data['createdAt'] != null ? data['createdAt'].toDate().toString() : '',
        data['updatedAt'] != null ? data['updatedAt'].toDate().toString() : '',
      ]);
    }

    // Convert to CSV string
    final csvData = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csvData);
    final Uint8List fileBytes = Uint8List.fromList(bytes);
    final fileName = 'family_data_${DateTime.now().toIso8601String()}.csv';

    if (kIsWeb) {
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: fileBytes,

        mimeType: MimeType.csv,
      );
    } else {
      // Request permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        print("Permission denied");
        return;
      }

      final directory = await getExternalStorageDirectory();
      final path = '${directory!.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(fileBytes);

      // Optional system dialog
      await FileSaver.instance.saveAs(
        name: fileName,
        bytes: fileBytes,

        mimeType: MimeType.csv,
        fileExtension: 'csv',
      );
    }
  } catch (e) {
    print('Error exporting CSV: $e');
  }
}
