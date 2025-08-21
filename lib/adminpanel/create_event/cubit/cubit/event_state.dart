part of 'event_cubit.dart';

sealed class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

final class EventInitial extends EventState {}

final class EventLoadingState extends EventState {}

final class EventSucess extends EventState {}

final class EventErrorState extends EventState {
  final String errorMessage;

  const EventErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
