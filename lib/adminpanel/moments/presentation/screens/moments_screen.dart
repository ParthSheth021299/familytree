import 'package:family_tree/adminpanel/moments/cubit/moments_cubit.dart';
import 'package:family_tree/adminpanel/moments/presentation/screens/moments_list_screen.dart';
import 'package:family_tree/adminpanel/moments/presentation/widgets/multiple_image_upload_widget.dart';
import 'package:family_tree/adminpanel/service/toast.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MomentsScreen extends StatefulWidget {
  const MomentsScreen({super.key});

  @override
  State<MomentsScreen> createState() => _MomentsScreenState();
}

class _MomentsScreenState extends State<MomentsScreen> {
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController captionEditingController =
      TextEditingController();

  List<String> uploadedUrls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addMoment),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MomentsListScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: titleEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.enterTitle,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: captionEditingController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.enterCaption,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                AppLocalizations.of(context)!.uploadImages,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              MultiImagePickerWidget(
                onImagesUploaded: (urls) {
                  setState(() {
                    uploadedUrls = urls;
                  });
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(AppLocalizations.of(context)!.saveMoment),
                onPressed: () {
                  if (titleEditingController.text.isEmpty) {
                    showToast(AppLocalizations.of(context)!.titleIsRequired);
                    return;
                  }

                  BlocProvider.of<MomentsCubit>(context).addMoments(
                    titleEditingController.text,
                    captionEditingController.text,
                    DateTime.now().toIso8601String(),
                    uploadedUrls,
                  );

                  showToast(AppLocalizations.of(context)!.momentSaved);
                  titleEditingController.clear();
                  captionEditingController.clear();
                  setState(() => uploadedUrls = []);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
