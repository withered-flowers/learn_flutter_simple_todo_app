import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_todo_app/cubits/todo_list/todo_list_cubit.dart';
import 'package:simple_todo_app/models/todo_model.dart';

part 'active_todo_count_state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  final TodoListCubit todoListCubit;
  final int initialActiveTodoCount;

  // Since this will be a computed which will be initialize later,
  // We need to use "late"
  late final StreamSubscription todoListSubscription;

  ActiveTodoCountCubit({
    required this.todoListCubit,
    required this.initialActiveTodoCount,
  }) : super(
          ActiveTodoCountState(activeTodoCount: initialActiveTodoCount),
        ) {
    // We will subscribe for the changes in TodoListState value
    todoListSubscription =
        todoListCubit.stream.listen((TodoListState todoListState) {
      // Debug purpose
      if (kDebugMode) {
        print('todoListState: $todoListState');
      }

      // We will set the computed value here
      final int currentActiveTodoCount = todoListState.todos
          .where((Todo todo) => !todo.completed)
          .toList()
          .length;

      emit(state.copyWith(activeTodoCount: currentActiveTodoCount));
    });
  }

  // Since we have a subscription, for not leaking, we need to have
  // a unsubscribe logic
  @override
  Future<void> close() {
    todoListSubscription.cancel();
    return super.close();
  }
}
