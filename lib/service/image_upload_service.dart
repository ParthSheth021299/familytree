import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageUploader {
  static const String apiKey = 'c99281799b230bff1a49cedec157eecf'; // replace this

  static Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey");
    final base64Image = base64Encode(await imageFile.readAsBytes());

    final response = await http.post(
      url,
      body: {
        "image": base64Image,
        "name": "family_member_${DateTime.now().millisecondsSinceEpoch}"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"]["url"]; // returns the direct image URL
    } else {
      print("Image upload failed: ${response.body}");
      return null;
    }
  }
}
