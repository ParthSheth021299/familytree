// class MomentsModel {
//   final String id;

//   final String title;
//   final String caption;
//   final List<String> imageUrl;

//   MomentsModel({
//     required this.id,
//     required this.title,
//     required this.caption,
//     required this.imageUrl,
//   });

//   factory MomentsModel.fromJson(Map<String, dynamic> json) {
//     return MomentsModel(
//       id: json['id'].toString(),
//       title: json['title'].toString(),
//       caption: json['caption'].toString(),
//       imageUrl: json['imageUrl'].toString(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {'id': id.toString(), 'title': title, 'caption': caption};
//   }

//   factory MomentsModel.empty() =>
//       MomentsModel(id: '', title: '', caption: '', imageUrl: '');
// }
// class MomentsModel {
//   final String id;
//   final String title;
//   final String caption;
//   final List<String> imageUrl;

//   MomentsModel({
//     required this.id,
//     required this.title,
//     required this.caption,
//     required this.imageUrl,
//   });

//   factory MomentsModel.fromJson(Map<String, dynamic> json) {
//     final imageData = json['imageUrl'];

//     List<String> imageList;
//     if (imageData is String) {
//       imageList = [imageData]; // wrap single string into a list
//     } else if (imageData is List) {
//       imageList = List<String>.from(imageData);
//     } else {
//       imageList = [];
//     }

//     return MomentsModel(
//       id: json['id'].toString(),
//       title: json['title'].toString(),
//       caption: json['caption'].toString(),
//       imageUrl: imageList,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'caption': caption,
//       'imageUrl': imageUrl, // ✅ export as List<String>
//     };
//   }

//   factory MomentsModel.empty() =>
//       MomentsModel(id: '', title: '', caption: '', imageUrl: []);
// }
class MomentsModel {
  final String id;
  final String title;
  final String caption;
  final List<String> imageUrl;

  MomentsModel({
    required this.id,
    required this.title,
    required this.caption,
    required this.imageUrl,
  });

  MomentsModel copyWith({
    String? id,
    String? title,
    String? caption,
    List<String>? imageUrl,
  }) {
    return MomentsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      // clone to avoid external mutation of the original list
      imageUrl: imageUrl ?? List<String>.from(this.imageUrl),
    );
  }

  factory MomentsModel.fromJson(Map<String, dynamic> json) {
    final imageData = json['imageUrl'];
    List<String> imageList;
    if (imageData is String) {
      imageList = [imageData];
    } else if (imageData is List) {
      imageList = List<String>.from(imageData);
    } else {
      imageList = [];
    }

    return MomentsModel(
      id: json['id'].toString(),
      title: json['title'].toString(),
      caption: json['caption'].toString(),
      imageUrl: imageList,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'caption': caption, 'imageUrl': imageUrl};
  }

  factory MomentsModel.empty() =>
      MomentsModel(id: '', title: '', caption: '', imageUrl: []);
}
