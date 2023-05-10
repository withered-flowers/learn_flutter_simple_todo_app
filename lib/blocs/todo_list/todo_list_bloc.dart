import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_todo_app/models/todo_model.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListState.initial()) {
    on<AddTodoEvent>(_addTodo);
    on<EditTodoEvent>(_editTodo);
    on<ToggleTodoEvent>(_toggleTodo);
    on<RemoveTodoEvent>(_deleteTodo);
  }

  // We copy this from TodoListCubit and modify it
  // Now it will have 2 args:
  // - AddTodoEvent
  // - Emitter<TodoListState>
  void _addTodo(AddTodoEvent event, Emitter<TodoListState> emit) {
    final newTodo = Todo(desc: event.todoDesc);
    final newTodos = [...state.todos, newTodo];

    emit(state.copyWith(todos: newTodos));
  }

  // We copy this from TodoListCubit and modify it
  // Now it will have 2 args:
  // - EditTodoEvent
  // - Emitter<TodoListState>
  void _editTodo(EditTodoEvent event, Emitter<TodoListState> emit) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == event.id) {
        return Todo(
          id: event.id,
          desc: event.todoDesc,
          completed: todo.completed,
        );
      }

      return todo;
    }).toList();

    emit(state.copyWith(todos: newTodos));
  }

  void _toggleTodo(ToggleTodoEvent event, Emitter<TodoListState> emit) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == event.id) {
        return Todo(
          id: todo.id,
          desc: todo.desc,
          completed: !todo.completed,
        );
      }

      return todo;
    }).toList();

    emit(state.copyWith(todos: newTodos));
  }

  void _deleteTodo(RemoveTodoEvent event, Emitter<TodoListState> emit) {
    final newTodos =
        state.todos.where((Todo todo) => event.todo.id != todo.id).toList();

    emit(state.copyWith(todos: newTodos));
  }
}
