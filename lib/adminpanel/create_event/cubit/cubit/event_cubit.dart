import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventInitial());
}
