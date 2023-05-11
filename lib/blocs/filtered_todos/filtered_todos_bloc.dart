import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_todo_app/blocs/blocs.dart';
import 'package:simple_todo_app/models/todo_model.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final List<Todo> initialTodos;
  final TodoFilterBloc todoFilterBloc;
  final TodoSearchBloc todoSearchBloc;
  final TodoListBloc todoListBloc;

  late StreamSubscription todoFilterSubscription;
  late StreamSubscription todoSearchSubscription;
  late StreamSubscription todoListSubscription;

  FilteredTodosBloc({
    required this.initialTodos,
    required this.todoFilterBloc,
    required this.todoSearchBloc,
    required this.todoListBloc,
  }) : super(FilteredTodosState(filteredTodos: initialTodos)) {
    todoFilterSubscription = todoFilterBloc.stream.listen(
      (TodoFilterState todoFilterState) {
        setFilteredTodos();
      },
    );

    todoSearchSubscription = todoSearchBloc.stream.listen(
      (TodoSearchState todoSearchState) {
        setFilteredTodos();
      },
    );

    todoListSubscription = todoListBloc.stream.listen(
      (TodoListState todoListState) {
        setFilteredTodos();
      },
    );

    on<CalculateFilteredTodosEvent>((event, emit) {
      emit(state.copyWith(filteredTodos: event.filteredTodos));
    });
  }

  // Since this function will be called outside this cubit,
  // We now need to provide arguments
  void setFilteredTodos() {
    List<Todo> filteredTodos;

    // Set based on filter
    switch (todoFilterBloc.state.filter) {
      case Filter.active:
        filteredTodos = todoListBloc.state.todos
            .where((Todo todo) => !todo.completed)
            .toList();
        break;
      case Filter.completed:
        filteredTodos = todoListBloc.state.todos
            .where((Todo todo) => todo.completed)
            .toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todoListBloc.state.todos;
        break;
    }

    if (todoSearchBloc.state.searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos
          .where(
            (Todo todo) => todo.desc
                .toLowerCase()
                .contains(todoSearchBloc.state.searchTerm.toLowerCase()),
          )
          .toList();
    }

    add(CalculateFilteredTodosEvent(filteredTodos: filteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterSubscription.cancel();
    todoSearchSubscription.cancel();
    todoListSubscription.cancel();
    return super.close();
  }
}
