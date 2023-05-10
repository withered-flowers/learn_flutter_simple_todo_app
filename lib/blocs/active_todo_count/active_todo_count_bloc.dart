import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_todo_app/blocs/blocs.dart';
import 'package:simple_todo_app/models/todo_model.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountBloc
    extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  final int initialActiveTodoCount;
  final TodoListBloc todoListBloc;

  // Now we will implement StreamSubscription for BLoC
  late final StreamSubscription todoListSubscription;

  ActiveTodoCountBloc({
    required this.initialActiveTodoCount,
    required this.todoListBloc,
  }) : super(ActiveTodoCountState(
          activeTodoCount: initialActiveTodoCount,
        )) {
    todoListBloc.stream.listen((TodoListState todoListState) {
      if (kDebugMode) {
        print('todoListState: $todoListState');
      }

      final int currentActiveTodoCount = todoListState.todos
          .where((Todo todo) => !todo.completed)
          .toList()
          .length;

      // instead of using emit, we will "invoke" (trigger) event using add
      add(
        CalculateActiveTodoCountEvent(activeTodoCount: currentActiveTodoCount),
      );
    });

    on<CalculateActiveTodoCountEvent>((event, emit) {
      emit(state.copyWith(activeTodoCount: event.activeTodoCount));
    });
  }

  // Since we're using StreamSubscription, we have to cancel the subsciption
  // onClose (to prevent memory leak)
  @override
  Future<void> close() {
    todoListSubscription.cancel();
    return super.close();
  }
}
