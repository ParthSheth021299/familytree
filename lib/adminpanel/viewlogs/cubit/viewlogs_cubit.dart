import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:family_tree/adminpanel/dependencies/dependencies.dart';
import 'package:family_tree/adminpanel/viewlogs/models/view_logs_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'viewlogs_state.dart';

class ViewlogsCubit extends Cubit<ViewlogsState> {
  ViewlogsCubit() : super(ViewlogsInitial());

  Future<void> viewUserLogs() async {
    emit(ViewlogsLoading());
    try {
      final logs = await viewLogsRepository.fetchUser();
      emit(ViewlogsSuccess(viewLogs: logs));
    } on FirebaseException catch (e) {
      emit(ViewlogsErrorState(errorMessage: e.message.toString()));
    }
  }

  Future<void> toggleUserActiveStatusByEmail({
    required String email,
    required bool isActive,
  }) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final docId = query.docs.first.id;
        await FirebaseFirestore.instance.collection('user').doc(docId).update({
          'isActive': isActive,
        });

        // Optionally refresh data
        viewUserLogs();
      } else {
        emit(
          ViewlogsErrorState(errorMessage: "User with email $email not found"),
        );
      }
    } catch (e) {
      emit(ViewlogsErrorState(errorMessage: "Failed to update status: $e"));
    }
  }
}
