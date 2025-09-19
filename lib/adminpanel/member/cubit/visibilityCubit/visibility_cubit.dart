import 'package:family_tree/adminpanel/member/model/visibility_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'visibility_state.dart';

class VisibilityCubit extends Cubit<VisibilityState> {
  VisibilityCubit() : super(const VisibilityState(loading: true));

  void fetchVisibility() {
    FirebaseFirestore.instance
        .collection('settings')
        .doc('treeVisibility')
        .snapshots()
        .listen((snapshot) {
          if (snapshot.exists) {
            emit(
              VisibilityState(
                visibility: VisibilityModel.fromJson(snapshot.data()!),
                loading: false,
              ),
            );
          }
        });
  }
}
