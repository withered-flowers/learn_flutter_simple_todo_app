import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_todo_app/cubits/todo_filter/todo_filter_cubit.dart';
import 'package:simple_todo_app/cubits/todo_list/todo_list_cubit.dart';
import 'package:simple_todo_app/cubits/todo_search/todo_search_cubit.dart';
import 'package:simple_todo_app/models/todo_model.dart';

part 'filtered_todos_state.dart';

class FilteredTodosCubit extends Cubit<FilteredTodosState> {
  // We will use the BlocListener
  // So, bye bye subscription and bye bye cubit in another cubit

  // Initial Value
  final List<Todo> initialTodos;

  FilteredTodosCubit({
    required this.initialTodos,
  }) : super(FilteredTodosState(filteredTodos: initialTodos));

  // Since this function will be called outside this cubit,
  // We now need to provide arguments
  void setFilteredTodos(Filter filter, List<Todo> todos, String searchTerm) {
    List<Todo> filteredTodos;

    // Set based on filter
    switch (filter) {
      case Filter.active:
        filteredTodos = todos.where((Todo todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        filteredTodos = todos.where((Todo todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todos;
        break;
    }

    if (searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos
          .where(
            (Todo todo) =>
                todo.desc.toLowerCase().contains(searchTerm.toLowerCase()),
          )
          .toList();
    }

    emit(state.copyWith(filteredTodos: filteredTodos));
  }

  // BlocListener will manage stream unsubscribe automatically
  // So, we don't need to use the close anymore
}
