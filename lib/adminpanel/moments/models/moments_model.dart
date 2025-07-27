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

  factory MomentsModel.fromJson(Map<String, dynamic> json) {
    final imageData = json['imageUrl'];

    List<String> imageList;
    if (imageData is String) {
      imageList = [imageData]; // wrap single string into a list
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
    return {
      'id': id,
      'title': title,
      'caption': caption,
      'imageUrl': imageUrl, // ✅ export as List<String>
    };
  }

  factory MomentsModel.empty() =>
      MomentsModel(id: '', title: '', caption: '', imageUrl: []);
}
