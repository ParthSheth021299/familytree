import 'package:family_tree/adminpanel/moments/cubit/moments_cubit.dart';
import 'package:family_tree/adminpanel/moments/presentation/screens/moments_list_screen.dart';
import 'package:family_tree/adminpanel/moments/presentation/widgets/multiple_image_upload_widget.dart';
import 'package:family_tree/adminpanel/service/toast.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.list_alt),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final isAdmin = prefs.getBool('isAdminLoggedIn');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MomentsListScreen(isAdmin: isAdmin ?? false),
                ),
              );
            },
            label: Text(AppLocalizations.of(context)!.viewAllMoments),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.createNewMoment,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.createNewMomentSubtitle,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                //Email
                Text(
                  AppLocalizations.of(context)!.enterTitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: titleEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)!.enterTitle,
                  ),
                ),
                const SizedBox(height: 20),

                //Caption
                Text(
                  AppLocalizations.of(context)!.enterCaption,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: captionEditingController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)!.enterCaption,
                  ),
                ),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.uploadImages,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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

                SizedBox(
                  // width: 250,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(AppLocalizations.of(context)!.saveMoment),
                    onPressed: () {
                      if (titleEditingController.text.isEmpty) {
                        showToast(
                          AppLocalizations.of(context)!.titleIsRequired,
                          isError: true,
                        );
                        return;
                      }
                      if (captionEditingController.text.isEmpty) {
                        showToast('Caption is required', isError: true);
                        return;
                      }
                      if (uploadedUrls.isEmpty) {
                        showToast('Upload Images', isError: true);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
