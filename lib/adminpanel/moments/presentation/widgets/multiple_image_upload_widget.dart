import 'dart:typed_data';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:family_tree/service/image_upload_service.dart';

class MultiImagePickerWidget extends StatefulWidget {
  final Function(List<String>) onImagesUploaded;

  const MultiImagePickerWidget({super.key, required this.onImagesUploaded});

  @override
  State<MultiImagePickerWidget> createState() => _MultiImagePickerWidgetState();
}

class _MultiImagePickerWidgetState extends State<MultiImagePickerWidget> {
  List<XFile> _selectedFiles = [];
  List<String> _uploadedUrls = [];
  bool _isUploading = false;
  final int _maxFileSizeMB = 32;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();

    if (files.isNotEmpty) {
      List<XFile> validFiles = [];

      for (var file in files) {
        int sizeInBytes = kIsWeb
            ? (await file.readAsBytes()).lengthInBytes
            : await io.File(file.path).length();

        double sizeInMB = sizeInBytes / (1024 * 1024);
        if (sizeInMB <= _maxFileSizeMB) {
          validFiles.add(file);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${file.name} exceeds 32MB limit.")),
          );
        }
      }

      setState(() {
        _selectedFiles = validFiles;
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedFiles.isEmpty) return;

    setState(() => _isUploading = true);
    List<String> uploaded = [];

    for (final file in _selectedFiles) {
      final imageData = kIsWeb ? await file.readAsBytes() : io.File(file.path);

      final url = await ImageUploader.uploadImage(imageData);
      if (url != null) uploaded.add(url);
    }

    setState(() {
      _uploadedUrls = uploaded;
      _isUploading = false;
      _selectedFiles.clear();
    });

    widget.onImagesUploaded(uploaded);
  }

  void _removeImage(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _clearAll() {
    setState(() {
      _selectedFiles.clear();
      _uploadedUrls.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedFiles.map((file) {
            final index = _selectedFiles.indexOf(file);
            return Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: FutureBuilder<Uint8List>(
                    future: file.readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Image.memory(snapshot.data!, fit: BoxFit.cover);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: const CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 12,
                      child: Icon(Icons.close, size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.image_search),
              label: const Text("Pick Images"),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _selectedFiles.isEmpty || _isUploading
                  ? null
                  : _uploadImages,
              icon: const Icon(Icons.upload),
              label: const Text("Upload Selected"),
            ),
            const SizedBox(width: 10),
            if (_selectedFiles.isNotEmpty || _uploadedUrls.isNotEmpty)
              TextButton(onPressed: _clearAll, child: const Text("Clear All")),
          ],
        ),
        if (_isUploading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: LinearProgressIndicator(),
          ),
        if (_uploadedUrls.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "✅ Uploaded ${_uploadedUrls.length} image(s)",
              style: TextStyle(color: Colors.green.shade700),
            ),
          ),
      ],
    );
  }
}
