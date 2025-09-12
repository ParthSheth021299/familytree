// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// void showImageGalleryDialog(
//   BuildContext context,
//   List<String> images,
//   int initialIndex,
// ) {
//   final pageController = PageController(initialPage: initialIndex);

//   showGeneralDialog(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: "Image Viewer",
//     useRootNavigator: true,
//     transitionDuration: const Duration(milliseconds: 300),
//     pageBuilder: (context, animation, secondaryAnimation) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             PageView.builder(
//               scrollDirection: Axis.horizontal,
//               controller: pageController,
//               itemCount: images.length,
//               itemBuilder: (context, index) {
//                 return CachedNetworkImage(
//                   imageUrl: images[index],

//                   fit: BoxFit.contain,
//                   errorWidget: (context, url, error) =>
//                       const Icon(Icons.broken_image),
//                   progressIndicatorBuilder: (context, url, progress) =>
//                       CircularProgressIndicator(),
//                 );
//               },
//             ),
//             Positioned(
//               top: MediaQuery.of(context).padding.top + 16,
//               right: 16,
//               child: IconButton(
//                 icon: const Icon(Icons.close, color: Colors.white, size: 30),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

void showImageGalleryDialog(
  BuildContext context,
  List<String> images,
  int initialIndex,
) {
  final pageController = PageController(initialPage: initialIndex);

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              allowImplicitScrolling: true,

              itemCount: images.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, color: Colors.white),
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            // Positioned(
            //   top: MediaQuery.of(context).padding.top + 16,
            //   right: 16,
            //   child: IconButton(
            //     icon: const Icon(Icons.close, color: Colors.white, size: 30),
            //     onPressed: () => Navigator.pop(context),
            //   ),
            // ),
          ],
        ),
      );
    },
  );
}
