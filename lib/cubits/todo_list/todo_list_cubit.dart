import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_todo_app/models/todo_model.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit() : super(TodoListState.initial());

  // Adding new Todo
  void addTodo(String todoDesc) {
    final newTodo = Todo(desc: todoDesc);

    // State is immutable, need to make new state value and replace it
    final newTodos = [...state.todos, newTodo];

    emit(state.copyWith(todos: newTodos));
  }

  // Edit todo
  void editTodo(String id, String todoDesc) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == id) {
        return Todo(
          id: id,
          desc: todoDesc,
          completed: todo.completed,
        );
      }

      return todo;
    }).toList();

    emit(state.copyWith(todos: newTodos));
  }

  // Complete the todo
  void toggleTodoCompleted(String id) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == id) {
        return Todo(
          id: todo.id,
          desc: todo.id,
          completed: !todo.completed,
        );
      }

      return todo;
    }).toList();

    emit(state.copyWith(todos: newTodos));
  }

  // Delete todo
  void deleteTodo(String id) {
    final newTodos = state.todos.where((Todo todo) => todo.id != id).toList();

    emit(state.copyWith(todos: newTodos));
  }
}
