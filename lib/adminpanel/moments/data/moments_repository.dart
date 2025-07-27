import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/moments/models/moments_model.dart';

class MomentsRepository {
  Future<String> createMoment(
    String title,
    String caption,
    String id,
    List<String> imageUrl,
  ) async {
    final momentData = {
      "id": id,
      "title": title,
      "caption": caption,
      "imageUrl": imageUrl,
    };
    await FirebaseFirestore.instance.collection('moments').add(momentData);
    return 'Moment Created Successfully';
  }

  Future<List<MomentsModel>> fetchMoments() async {
    final snapshots = await FirebaseFirestore.instance
        .collection('moments')
        .get();
    return snapshots.docs
        .map((docs) => MomentsModel.fromJson(docs.data()))
        .toList();
  }
}
