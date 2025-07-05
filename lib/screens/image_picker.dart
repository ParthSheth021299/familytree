// import 'dart:io';
// import 'package:family_tree/service/image_upload_service.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//  // Assuming you created the ImgBB uploader here

// class ImagePickerWidget extends StatefulWidget {
//   final Function(String) onImageUploaded;

//   const ImagePickerWidget({super.key, required this.onImageUploaded});

//   @override
//   State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
// }

// class _ImagePickerWidgetState extends State<ImagePickerWidget> {
//   File? _selectedImage;
//   String? _uploadedUrl;
//   bool _isUploading = false;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//         _isUploading = true;
//       });

//       final uploadedUrl = await ImageUploader.uploadImage(_selectedImage!);

//       if (uploadedUrl != null) {
//         setState(() {
//           _uploadedUrl = uploadedUrl;
//           _isUploading = false;
//         });

//         widget.onImageUploaded(uploadedUrl); // pass URL back
//       } else {
//         setState(() => _isUploading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Image upload failed")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (_selectedImage != null)
//           Image.file(_selectedImage!, height: 120, width: 120, fit: BoxFit.cover)
//         else
//           Container(
//             height: 120,
//             width: 120,
//             color: Colors.grey.shade300,
//             child: const Icon(Icons.image, size: 50),
//           ),
//         const SizedBox(height: 8),
//         _isUploading
//             ? const CircularProgressIndicator()
//             : ElevatedButton.icon(
//                 onPressed: _pickImage,
//                 icon: const Icon(Icons.upload),
//                 label: const Text("Upload Photo"),
//               ),
//         if (_uploadedUrl != null)
//           Text("Uploaded", style: TextStyle(color: Colors.green.shade700)),
//       ],
//     );
//   }
// }
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:family_tree/service/image_upload_service.dart';
import 'dart:io' as io;

class ImagePickerWidget extends StatefulWidget {
  final Function(String) onImageUploaded;

  const ImagePickerWidget({super.key, required this.onImageUploaded});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Uint8List? _webImageBytes;
  io.File? _mobileImageFile;
  String? _uploadedUrl;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _uploadedUrl = null;
        _webImageBytes = null;
        _mobileImageFile = null;
        _isUploading = true;
      });

      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() => _webImageBytes = bytes);
      } else {
        setState(() => _mobileImageFile = io.File(pickedFile.path));
      }

      final imageData = kIsWeb ? _webImageBytes : _mobileImageFile;

      final uploadedUrl = await ImageUploader.uploadImage(imageData);

      if (uploadedUrl != null) {
        setState(() {
          _uploadedUrl = uploadedUrl;
          _isUploading = false;
        });
        widget.onImageUploaded(uploadedUrl);
      } else {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Image upload failed")));
      }
    }
  }

  void _clearImage() {
    setState(() {
      _webImageBytes = null;
      _mobileImageFile = null;
      _uploadedUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = kIsWeb ? _webImageBytes != null : _mobileImageFile != null;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 120,
              width: 120,
              color: Colors.grey.shade300,
              child: hasImage
                  ? kIsWeb
                        ? Image.memory(_webImageBytes!, fit: BoxFit.cover)
                        : Image.file(_mobileImageFile!, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 50),
            ),
            if (hasImage)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: _clearImage,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        _isUploading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload),
                label: Text(
                  _uploadedUrl != null ? "Re-upload" : "Upload Photo",
                ),
              ),
        if (_uploadedUrl != null)
          Text("✅ Uploaded", style: TextStyle(color: Colors.green.shade700)),
      ],
    );
  }
}
