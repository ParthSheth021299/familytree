part of 'moments_cubit.dart';

sealed class MomentsState extends Equatable {
  const MomentsState();

  @override
  List<Object> get props => [];
}

final class MomentsInitial extends MomentsState {}

final class MomentshLoadingState extends MomentsState {}

final class MomentsSucess extends MomentsState {}

final class MomentFetchSucess extends MomentsState {
  final List<MomentsModel> moments;

  const MomentFetchSucess({required this.moments});
}

final class MomentsErrorState extends MomentsState {
  final String errorMessage;

  const MomentsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
