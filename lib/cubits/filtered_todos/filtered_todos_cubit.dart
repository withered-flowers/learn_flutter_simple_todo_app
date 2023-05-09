import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_todo_app/cubits/todo_filter/todo_filter_cubit.dart';
import 'package:simple_todo_app/cubits/todo_list/todo_list_cubit.dart';
import 'package:simple_todo_app/cubits/todo_search/todo_search_cubit.dart';
import 'package:simple_todo_app/models/todo_model.dart';

part 'filtered_todos_state.dart';

class FilteredTodosCubit extends Cubit<FilteredTodosState> {
  // Another Cubit to listen to
  final TodoFilterCubit todoFilterCubit;
  final TodoSearchCubit todoSearchCubit;
  final TodoListCubit todoListCubit;

  // Subscription for computed value using StreamSubscription
  late StreamSubscription todoFilterSubscription;
  late StreamSubscription todoSearchSubscription;
  late StreamSubscription todoListSubscription;

  // Initial Value
  final List<Todo> initialTodos;

  FilteredTodosCubit({
    required this.todoFilterCubit,
    required this.todoSearchCubit,
    required this.todoListCubit,
    required this.initialTodos,
  }) : super(FilteredTodosState(filteredTodos: initialTodos)) {
    // Construct the subscription

    // Stream to TodoFilterState changed
    todoFilterSubscription = todoFilterCubit.stream.listen(
      (TodoFilterState todoFilterState) {
        setFilteredTodos();
      },
    );

    // Stream to TodoSearchState changed
    todoSearchSubscription = todoSearchCubit.stream.listen(
      (TodoSearchState todoSearchState) {
        setFilteredTodos();
      },
    );

    // Stream to TodoListState changed
    todoListSubscription = todoListCubit.stream.listen(
      (TodoListState todoListState) {
        setFilteredTodos();
      },
    );
  }

  void setFilteredTodos() {
    List<Todo> filteredTodos;

    // Set based on filter
    switch (todoFilterCubit.state.filter) {
      case Filter.active:
        filteredTodos = todoListCubit.state.todos
            .where((Todo todo) => !todo.completed)
            .toList();
        break;
      case Filter.completed:
        filteredTodos = todoListCubit.state.todos
            .where((Todo todo) => todo.completed)
            .toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todoListCubit.state.todos;
        break;
    }

    if (todoSearchCubit.state.searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos
          .where(
            (Todo todo) => todo.desc
                .toLowerCase()
                .contains(todoSearchCubit.state.searchTerm),
          )
          .toList();
    }

    emit(state.copyWith(filteredTodos: filteredTodos));
  }

  // Since we have a subscription, for not leaking, we need to have
  // a unsubscribe logic
  @override
  Future<void> close() {
    todoFilterSubscription.cancel();
    todoSearchSubscription.cancel();
    todoListSubscription.cancel();

    return super.close();
  }
}
