import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_app/cubits/cubits.dart';
import 'package:simple_todo_app/models/todo_model.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodosCubit>().state.filteredTodos;

    // Now we will wrap this inside the MultiBlocListener
    // Since we need to listen to 3 Cubit here
    return MultiBlocListener(
      listeners: [
        BlocListener<TodoListCubit, TodoListState>(
          listener: (context, state) {
            // We will read from FilteredTodosCubit to call setFilteredTodos
            // This function takes 3 arguments
            // - Filter filter,
            // - List<Todo> todos, and
            // - String searchTerm

            // Since we listen from TodoListCubit
            // we can read todos directly from state (state.todos)
            context.read<FilteredTodosCubit>().setFilteredTodos(
                  context.read<TodoFilterCubit>().state.filter,
                  state.todos,
                  context.read<TodoSearchCubit>().state.searchTerm,
                );
          },
        ),
        BlocListener<TodoFilterCubit, TodoFilterState>(
          listener: (context, state) {
            // We will read from FilteredTodosCubit to call setFilteredTodos
            // This function takes 3 arguments
            // - Filter filter,
            // - List<Todo> todos, and
            // - String searchTerm

            // Since we listen from TodoFilterCubit
            // we can read filter directly from state (state.filter)
            context.read<FilteredTodosCubit>().setFilteredTodos(
                  state.filter,
                  context.read<TodoListCubit>().state.todos,
                  context.read<TodoSearchCubit>().state.searchTerm,
                );
          },
        ),
        BlocListener<TodoSearchCubit, TodoSearchState>(
          listener: (context, state) {
            // We will read from FilteredTodosCubit to call setFilteredTodos
            // This function takes 3 arguments
            // - Filter filter,
            // - List<Todo> todos, and
            // - String searchTerm

            // Since we listen from TodoSearchCubit
            // we can read searchTerm directly from state (state.searchTerm)
            context.read<FilteredTodosCubit>().setFilteredTodos(
                  context.read<TodoFilterCubit>().state.filter,
                  context.read<TodoListCubit>().state.todos,
                  state.searchTerm,
                );
          },
        ),
      ],
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: todos.length,
        separatorBuilder: (context, index) {
          return const Divider(color: Colors.grey);
        },
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(todos[index].id),
            background: showBackground(0),
            secondaryBackground: showBackground(1),
            child: TodoItem(
              todo: todos[index],
            ),
            onDismissed: (_) {
              context.read<TodoListCubit>().deleteTodo(todos[index].id);
            },
            confirmDismiss: (_) {
              return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text("Do you really want to delete?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("NO"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("YES"),
                      )
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget showBackground(int direction) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        size: 24.0,
        color: Colors.white,
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;

  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            bool isError = false;
            textController.text = widget.todo.desc;

            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('Edit Todo'),
                  content: TextField(
                    controller: textController,
                    autofocus: true,
                    decoration: InputDecoration(
                      errorText: isError ? "Value cannot be empty" : null,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("CANCEL"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isError = textController.text.isEmpty ? true : false;

                          if (!isError) {
                            context
                                .read<TodoListCubit>()
                                .editTodo(widget.todo.id, textController.text);

                            Navigator.pop(context);
                          }
                        });
                      },
                      child: const Text("EDIT"),
                    )
                  ],
                );
              },
            );
          },
        );
      },
      leading: Checkbox(
        value: widget.todo.completed,
        onChanged: (bool? checked) {
          context.read<TodoListCubit>().toggleTodoCompleted(widget.todo.id);
        },
      ),
      title: Text(widget.todo.desc),
    );
  }
}
