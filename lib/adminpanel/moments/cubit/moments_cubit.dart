import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:family_tree/adminpanel/dependencies/dependencies.dart';
import 'package:family_tree/adminpanel/moments/models/moments_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'moments_state.dart';

class MomentsCubit extends Cubit<MomentsState> {
  MomentsCubit() : super(MomentsInitial());

  //add moments
  Future<void> addMoments(
    String title,
    String caption,
    String id,
    List<String> imageUrl,
  ) async {
    emit(MomentshLoadingState());
    try {
      await momentRepository.createMoment(title, caption, id, imageUrl);
      emit(MomentsSucess());
    } on FirebaseException catch (e) {
      emit(MomentsErrorState(errorMessage: e.message.toString()));
    }
  }

  //Fetch moments
  Future<void> fetchMoments() async {
    emit(MomentshLoadingState());
    try {
      final moments = await momentRepository.fetchMoments();
      emit(MomentFetchSucess(moments: moments));
    } on FirebaseException catch (e) {
      emit(MomentsErrorState(errorMessage: e.message.toString()));
    }
  }
}
