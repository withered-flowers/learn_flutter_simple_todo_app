import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountBloc
    extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  ActiveTodoCountBloc() : super(ActiveTodoCountState.initial()) {
    on<CalculateActiveTodoCountEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
