// import 'package:family_tree/l10n/app_localizations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:family_tree/adminpanel/moments/cubit/moments_cubit.dart';
// import 'package:family_tree/adminpanel/moments/presentation/widgets/image_dailog.dart';

// class MomentsListScreen extends StatefulWidget {
//   const MomentsListScreen({super.key});

//   @override
//   State<MomentsListScreen> createState() => _MomentsListScreenState();
// }

// class _MomentsListScreenState extends State<MomentsListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<MomentsCubit>(context).fetchMoments();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.familyMoments),
//         centerTitle: true,
//         // backgroundColor: Colors.indigo.shade600,
//       ),
//       backgroundColor: Colors.grey.shade100,
//       body: BlocBuilder<MomentsCubit, MomentsState>(
//         builder: (context, state) {
//           if (state is MomentshLoadingState) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is MomentFetchSucess) {
//             final moments = state.moments;

//             return ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               itemCount: moments.length,
//               itemBuilder: (context, index) {
//                 final moment = moments[index];
//                 return Center(
//                   child: ConstrainedBox(
//                     constraints: const BoxConstraints(maxWidth: 900),
//                     child: Card(
//                       margin: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       elevation: 6,
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Title
//                             Text(
//                               moment.title,
//                               style: Theme.of(context).textTheme.headlineSmall
//                                   ?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     // color: Colors.indigo.shade800,s
//                                   ),
//                             ),
//                             const SizedBox(height: 16),

//                             // Horizontal image scroll
//                             SizedBox(
//                               height: 220,
//                               child: ListView.separated(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: moment.imageUrl.length,
//                                 separatorBuilder: (_, __) =>
//                                     const SizedBox(width: 12),
//                                 itemBuilder: (context, imgIndex) {
//                                   final imageUrl = moment.imageUrl[imgIndex];
//                                   return GestureDetector(
//                                     onTap: () {
//                                       showImageGalleryDialog(
//                                         context,
//                                         moment.imageUrl,
//                                         imgIndex,
//                                       );
//                                     },
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(12),
//                                       child: Image.network(
//                                         imageUrl,
//                                         width: 200,
//                                         fit: BoxFit.cover,
//                                         errorBuilder:
//                                             (context, error, stackTrace) {
//                                               return Container(
//                                                 color: Colors.grey.shade200,
//                                                 width: 200,
//                                                 child: const Icon(
//                                                   Icons.broken_image,
//                                                   size: 60,
//                                                 ),
//                                               );
//                                             },
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             const SizedBox(height: 16),

//                             // Caption
//                             Text(
//                               moment.caption,
//                               style: Theme.of(context).textTheme.bodyLarge
//                                   ?.copyWith(
//                                     fontSize: 16,
//                                     color: Colors.grey.shade800,
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else if (state is MomentsErrorState) {
//             return Center(child: Text("Error: ${state.errorMessage}"));
//           } else {
//             return const SizedBox();
//           }
//         },
//       ),
//     );
//   }
// }
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:family_tree/adminpanel/moments/models/moments_model.dart';
// import 'package:family_tree/l10n/app_localizations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:family_tree/adminpanel/moments/cubit/moments_cubit.dart';
// import 'package:family_tree/adminpanel/moments/presentation/widgets/image_dailog.dart';
// import 'package:image_picker/image_picker.dart';

// class MomentsListScreen extends StatefulWidget {
//   final bool isAdmin; // 👈 pass this from login/session

//   const MomentsListScreen({super.key, required this.isAdmin});

//   @override
//   State<MomentsListScreen> createState() => _MomentsListScreenState();
// }

// class _MomentsListScreenState extends State<MomentsListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<MomentsCubit>(context).fetchMoments();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.familyMoments),
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.grey.shade100,
//       body: BlocBuilder<MomentsCubit, MomentsState>(
//         builder: (context, state) {
//           if (state is MomentshLoadingState) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is MomentFetchSucess) {
//             final moments = state.moments;

//             return ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               itemCount: moments.length,
//               itemBuilder: (context, index) {
//                 final moment = moments[index];
//                 return Center(
//                   child: ConstrainedBox(
//                     constraints: const BoxConstraints(maxWidth: 900),
//                     child: Card(
//                       margin: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       elevation: 6,
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Row with Title + Admin Actions
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   moment.title,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .headlineSmall
//                                       ?.copyWith(fontWeight: FontWeight.bold),
//                                 ),
//                                 if (widget.isAdmin) // 👈 only for admins
//                                   Row(
//                                     children: [
//                                       IconButton(
//                                         icon: const Icon(
//                                           Icons.edit,
//                                           color: Colors.blue,
//                                         ),
//                                         onPressed: () {
//                                           // showEditMomentDialog(context, moment, (
//                                           //   updatedMoment,
//                                           // ) {
//                                           //   // 👇 call cubit to update state + backend
//                                           //   context
//                                           //       .read<MomentsCubit>()
//                                           //       .updateMoment(updatedMoment);
//                                           // });
//                                           showEditMomentDialog(
//                                             context,
//                                             moment, // the moment you want to edit
//                                             (updatedMoment) async {
//                                               // Handle save logic here
//                                               // Example: update Firestore or your state management

//                                               await FirebaseFirestore.instance
//                                                   .collection('moments')
//                                                   .doc(updatedMoment.id)
//                                                   .update(
//                                                     updatedMoment.toJson(),
//                                                   );

//                                               // OR if you’re using a Cubit/BLoC, call your update method
//                                               // context.read<MomentsCubit>().updateMoment(updatedMoment);
//                                             },
//                                           );
//                                         },
//                                       ),

//                                       IconButton(
//                                         icon: const Icon(
//                                           Icons.delete,
//                                           color: Colors.red,
//                                         ),
//                                         onPressed: () {
//                                           _confirmDelete(context, moment.id);
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                               ],
//                             ),

//                             const SizedBox(height: 16),

//                             // Horizontal image scroll
//                             SizedBox(
//                               height: 220,
//                               child: ListView.separated(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: moment.imageUrl.length,
//                                 separatorBuilder: (_, __) =>
//                                     const SizedBox(width: 12),
//                                 itemBuilder: (context, imgIndex) {
//                                   final imageUrl = moment.imageUrl[imgIndex];
//                                   return GestureDetector(
//                                     onTap: () {
//                                       showImageGalleryDialog(
//                                         context,
//                                         moment.imageUrl,
//                                         imgIndex,
//                                       );
//                                     },
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(12),
//                                       child: Image.network(
//                                         imageUrl,
//                                         width: 200,
//                                         fit: BoxFit.cover,
//                                         errorBuilder:
//                                             (context, error, stackTrace) {
//                                               return Container(
//                                                 color: Colors.grey.shade200,
//                                                 width: 200,
//                                                 child: const Icon(
//                                                   Icons.broken_image,
//                                                   size: 60,
//                                                 ),
//                                               );
//                                             },
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),

//                             const SizedBox(height: 16),

//                             // Caption
//                             Text(
//                               moment.caption,
//                               style: Theme.of(context).textTheme.bodyLarge
//                                   ?.copyWith(
//                                     fontSize: 16,
//                                     color: Colors.grey.shade800,
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else if (state is MomentsErrorState) {
//             return Center(child: Text("Error: ${state.errorMessage}"));
//           } else {
//             return const SizedBox();
//           }
//         },
//       ),
//     );
//   }

//   // Confirmation dialog for delete
//   void _confirmDelete(BuildContext context, String momentId) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Delete Moment"),
//         content: const Text("Are you sure you want to delete this moment?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // BlocProvider.of<MomentsCubit>(context).deleteMoment(momentId);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> showEditMomentDialog(
//     BuildContext context,
//     MomentsModel moment,
//     Function(MomentsModel updatedMoment) onSave,
//   ) async {
//     final titleController = TextEditingController(text: moment.title);
//     final captionController = TextEditingController(text: moment.caption);

//     List<String> imageUrls = List.from(moment.imageUrl); // existing images
//     final ImagePicker picker = ImagePicker();

//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               title: const Text(
//                 "Edit Moment",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               content: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Title field
//                     TextField(
//                       controller: titleController,
//                       decoration: const InputDecoration(
//                         labelText: "Title",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Caption field
//                     TextField(
//                       controller: captionController,
//                       maxLines: 3,
//                       decoration: const InputDecoration(
//                         labelText: "Caption",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Image List
//                     Text(
//                       "Images",
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     const SizedBox(height: 8),

//                     SizedBox(
//                       height: 120,
//                       child: ListView.separated(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: imageUrls.length + 1, // +1 for add button
//                         separatorBuilder: (_, __) => const SizedBox(width: 12),
//                         itemBuilder: (context, index) {
//                           if (index == imageUrls.length) {
//                             // Add new image button
//                             return GestureDetector(
//                               onTap: () async {
//                                 final XFile? pickedFile = await picker
//                                     .pickImage(source: ImageSource.gallery);
//                                 if (pickedFile != null) {
//                                   setState(() {
//                                     imageUrls.add(
//                                       pickedFile.path,
//                                     ); // local file path
//                                   });
//                                 }
//                               },
//                               child: Container(
//                                 width: 100,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                   color: Colors.grey.shade200,
//                                 ),
//                                 child: const Icon(Icons.add_a_photo, size: 40),
//                               ),
//                             );
//                           }

//                           final imageUrl = imageUrls[index];
//                           return Stack(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: imageUrl.startsWith("http")
//                                     ? Image.network(
//                                         imageUrl,
//                                         width: 100,
//                                         height: 100,
//                                         fit: BoxFit.cover,
//                                       )
//                                     : Image.file(
//                                         File(imageUrl),
//                                         width: 100,
//                                         height: 100,
//                                         fit: BoxFit.cover,
//                                       ),
//                               ),
//                               Positioned(
//                                 right: 4,
//                                 top: 4,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       imageUrls.removeAt(index);
//                                     });
//                                   },
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.black54,
//                                     ),
//                                     padding: const EdgeInsets.all(4),
//                                     child: const Icon(
//                                       Icons.close,
//                                       size: 16,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Cancel"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final updatedMoment = moment.copyWith(
//                       title: titleController.text.trim(),
//                       caption: captionController.text.trim(),
//                       imageUrl: imageUrls,
//                     );

//                     onSave(updatedMoment); // pass back updated moment
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Save"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/moments/models/moments_model.dart';
import 'package:family_tree/adminpanel/moments/presentation/widgets/multiple_image_upload_widget.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_tree/adminpanel/moments/cubit/moments_cubit.dart';
import 'package:family_tree/adminpanel/moments/presentation/widgets/image_dailog.dart';
import 'package:image_picker/image_picker.dart';

class MomentsListScreen extends StatefulWidget {
  bool isAdmin;

  MomentsListScreen({super.key, this.isAdmin = false});

  @override
  State<MomentsListScreen> createState() => _MomentsListScreenState();
}

class _MomentsListScreenState extends State<MomentsListScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MomentsCubit>(context).fetchMoments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.familyMoments),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade100,
      body: BlocBuilder<MomentsCubit, MomentsState>(
        builder: (context, state) {
          if (state is MomentshLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MomentFetchSucess) {
            final moments = state.moments;

            return moments.isEmpty
                ? Center(child: Text('No Moments'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: moments.length,
                    itemBuilder: (context, index) {
                      final moment = moments[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row with Title + Admin Actions
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        moment.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      if (widget.isAdmin)
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () async {
                                                // ✅ call the dialog
                                                await showEditMomentDialog(context, moment, (
                                                  updatedMoment,
                                                ) async {
                                                  print(
                                                    "MOMENT ${updatedMoment.title}",
                                                  );
                                                  // await FirebaseFirestore.instance
                                                  //     .collection('moments')
                                                  //     .doc(updatedMoment.id)
                                                  //     .update(
                                                  //       updatedMoment.toJson(),
                                                  //     );
                                                  // await FirebaseFirestore.instance
                                                  //     .collection('moments')
                                                  //     .doc(
                                                  //       moment.id,
                                                  //     ) // now this is Firestore’s actual doc id
                                                  //     .update(moment.toJson());

                                                  // refresh cubit after update
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                _confirmDelete(
                                                  context,
                                                  moment.id,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Horizontal image scroll
                                  SizedBox(
                                    height: 220,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: moment.imageUrl.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(width: 12),
                                      itemBuilder: (context, imgIndex) {
                                        final imageUrl =
                                            moment.imageUrl[imgIndex];
                                        return GestureDetector(
                                          onTap: () {
                                            showImageGalleryDialog(
                                              context,
                                              moment.imageUrl,
                                              imgIndex,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              imageUrl,
                                              width: 200,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color:
                                                          Colors.grey.shade200,
                                                      width: 200,
                                                      child: const Icon(
                                                        Icons.broken_image,
                                                        size: 60,
                                                      ),
                                                    );
                                                  },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Caption
                                  Text(
                                    moment.caption,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          fontSize: 16,
                                          color: Colors.grey.shade800,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          } else if (state is MomentsErrorState) {
            return Center(child: Text("Error: ${state.errorMessage}"));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String momentId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Moment"),
        content: const Text("Are you sure you want to delete this moment?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              BlocProvider.of<MomentsCubit>(context).deleteMoment(momentId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> showEditMomentDialog(
    BuildContext context,
    MomentsModel moment,
    Function(MomentsModel updatedMoment) onSave,
  ) async {
    final titleController = TextEditingController(text: moment.title);
    final captionController = TextEditingController(text: moment.caption);
    List<String> uploadedUrls = moment.imageUrl;

    List<String> imageUrls = List.from(moment.imageUrl);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.orangePrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edit Moment",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.enterTitle,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: captionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(
                              context,
                            )!.enterCaption,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.image,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),

                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageUrls.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final imageUrl = imageUrls[index];
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: imageUrl.startsWith("http")
                                        ? Image.network(
                                            imageUrl,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(imageUrl),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  // Positioned(
                                  //   right: 4,
                                  //   top: 4,
                                  //   child: GestureDetector(
                                  //     onTap: () {
                                  //       print(
                                  //         "${imageUrls.remove(imageUrl[index])}",
                                  //       );

                                  //       setState(() {
                                  //         imageUrls.remove(imageUrl[index]);
                                  //       });
                                  //     },
                                  //     child: Container(
                                  //       decoration: const BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: Colors.black54,
                                  //       ),
                                  //       padding: const EdgeInsets.all(4),
                                  //       child: const Icon(
                                  //         Icons.close,
                                  //         size: 16,
                                  //         color: Colors.white,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              );
                            },
                          ),
                        ),
                        MultiImagePickerWidget(
                          onImagesUploaded: (urls) {
                            setState(() {
                              imageUrls.addAll(urls);
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 90,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.save),
                            onPressed: () async {
                              final updatedMoment = moment.copyWith(
                                title: titleController.text.trim(),
                                caption: captionController.text.trim(),
                                imageUrl: imageUrls,
                              );
                              // onSave(updatedMoment);
                              await FirebaseFirestore.instance
                                  .collection('moments')
                                  .doc(
                                    moment.id,
                                  ) // now this is Firestore’s actual doc id
                                  .update(updatedMoment.toJson());
                              if (context.mounted) {
                                context.read<MomentsCubit>().fetchMoments();
                              }
                              Navigator.pop(context);
                            },

                            label: Text(
                              AppLocalizations.of(context)!.saveMoment,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
