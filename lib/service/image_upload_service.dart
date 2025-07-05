// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;

// class ImageUploader {
//   static const String apiKey = 'c99281799b230bff1a49cedec157eecf'; // replace this

//   static Future<String?> uploadImage(File imageFile) async {
//     final url = Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey");
//     final base64Image = base64Encode(await imageFile.readAsBytes());

//     final response = await http.post(
//       url,
//       body: {
//         "image": base64Image,
//         "name": "family_member_${DateTime.now().millisecondsSinceEpoch}"
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data["data"]["url"]; // returns the direct image URL
//     } else {
//       print("Image upload failed: ${response.body}");
//       return null;
//     }
//   }
// }
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ImageUploader {
  static Future<String?> uploadImage(dynamic imageData) async {
    const String apiKey = "c99281799b230bff1a49cedec157eecf";

    try {
      final bytes = kIsWeb
          ? imageData as Uint8List
          : await (imageData as io.File).readAsBytes();

      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey"),
        body: {'image': base64Image},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['url'];
      }
    } catch (e) {
      print("Upload failed: $e");
    }

    return null;
  }
}
