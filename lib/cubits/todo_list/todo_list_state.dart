part of 'todo_list_cubit.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;

  const TodoListState({
    required this.todos,
  });

  factory TodoListState.initial() {
    // Assumption:
    // All Initial State have completed set to false
    return TodoListState(
      todos: [
        Todo(id: '1', desc: "Learning Dart", completed: true),
        Todo(id: '2', desc: "Learning Flutter"),
        Todo(id: '3', desc: "Learning State Management"),
      ],
    );
  }

  @override
  List<Object?> get props => [todos];

  @override
  String toString() => 'TodoListState(todos: $todos)';

  TodoListState copyWith({List<Todo>? todos}) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }
}
