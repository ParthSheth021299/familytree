import 'package:cached_network_image/cached_network_image.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:flutter/material.dart';

void showImageGalleryDialog(
  BuildContext context,
  List<String> images,
  int initialIndex,
) {
  final pageController = PageController(initialPage: initialIndex);

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Image Viewer",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  child: Center(
                    // child: Image.network(
                    //   images[index],
                    //   fit: BoxFit.contain,
                    //   errorBuilder: (context, error, stackTrace) => const Icon(
                    //     Icons.broken_image,
                    //     size: 100,
                    //     color: Colors.white,
                    //   ),
                    //   loadingBuilder: (context, child, loadingProgress) {
                    //     if (loadingProgress == null) {
                    //       // ✅ Image loaded successfully → return actual image
                    //       return child;
                    //     }
                    //     // ⏳ While loading → show progress
                    //     return const Center(
                    //       child: CircularProgressIndicator(
                    //         color: AppColors.orangeDark,
                    //       ),
                    //     );
                    //   },
                    // ),
                    child: CachedNetworkImage(
                      imageUrl: images[index],

                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image),
                      progressIndicatorBuilder: (context, url, progress) =>
                          CircularProgressIndicator(),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    },
  );
}
