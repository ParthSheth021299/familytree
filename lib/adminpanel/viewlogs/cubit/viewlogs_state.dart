part of 'viewlogs_cubit.dart';

sealed class ViewlogsState extends Equatable {
  const ViewlogsState();

  @override
  List<Object> get props => [];
}

final class ViewlogsInitial extends ViewlogsState {}

final class ViewlogsLoading extends ViewlogsState {}

final class ViewlogsSuccess extends ViewlogsState {
  final List<ViewLogsModel> viewLogs;

  const ViewlogsSuccess({required this.viewLogs});
}

final class ViewlogsErrorState extends ViewlogsState {
  final String errorMessage;

  const ViewlogsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
