import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/viewlogs/models/view_logs_model.dart';

class ViewLogsRepository {
  Future<List<ViewLogsModel>> fetchUser() async {
    final snapshots = await FirebaseFirestore.instance.collection('user').get();
    return snapshots.docs
        .map((docs) => ViewLogsModel.fromJson(docs.data()))
        .toList();
  }
}
