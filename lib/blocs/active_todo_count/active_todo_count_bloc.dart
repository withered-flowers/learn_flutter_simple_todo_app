import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountBloc
    extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  final int initialActiveTodoCount;

  // Since we will use BLoC Listener, this won't be needed anymore
  // We won't use StreamSubscription anymore

  ActiveTodoCountBloc({
    required this.initialActiveTodoCount,
  }) : super(ActiveTodoCountState(
          activeTodoCount: initialActiveTodoCount,
        )) {
    on<CalculateActiveTodoCountEvent>((event, emit) {
      emit(state.copyWith(activeTodoCount: event.activeTodoCount));
    });
  }
}
