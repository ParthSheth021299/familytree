import 'dart:io';
import 'package:family_tree/service/image_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
 // Assuming you created the ImgBB uploader here

class ImagePickerWidget extends StatefulWidget {
  final Function(String) onImageUploaded;

  const ImagePickerWidget({super.key, required this.onImageUploaded});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _selectedImage;
  String? _uploadedUrl;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isUploading = true;
      });

      final uploadedUrl = await ImageUploader.uploadImage(_selectedImage!);

      if (uploadedUrl != null) {
        setState(() {
          _uploadedUrl = uploadedUrl;
          _isUploading = false;
        });

        widget.onImageUploaded(uploadedUrl); // pass URL back
      } else {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image upload failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedImage != null)
          Image.file(_selectedImage!, height: 120, width: 120, fit: BoxFit.cover)
        else
          Container(
            height: 120,
            width: 120,
            color: Colors.grey.shade300,
            child: const Icon(Icons.image, size: 50),
          ),
        const SizedBox(height: 8),
        _isUploading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload),
                label: const Text("Upload Photo"),
              ),
        if (_uploadedUrl != null)
          Text("Uploaded", style: TextStyle(color: Colors.green.shade700)),
      ],
    );
  }
}
