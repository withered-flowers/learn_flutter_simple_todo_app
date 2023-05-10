import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_todo_app/models/todo_model.dart';

part 'todo_filter_event.dart';
part 'todo_filter_state.dart';

class TodoFilterBloc extends Bloc<TodoFilterEvent, TodoFilterState> {
  TodoFilterBloc() : super(TodoFilterState.initial()) {
    // Since we are already implementing the ChangeFilterEvent
    // We will listen onChangeFilterEvent is triggered
    on<ChangeFilterEvent>((event, emit) {
      // We will emit something from state (copyWith)
      // which will get the value (filter) from the event (event.newFilter)
      emit(state.copyWith(filter: event.newFilter));
    });
  }
}
