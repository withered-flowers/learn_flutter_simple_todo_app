import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_app/blocs/blocs.dart';
import 'package:simple_todo_app/models/todo_model.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  // Since this function will be called outside this cubit,
  // We now need to provide arguments
  List<Todo> setFilteredTodos(
    Filter filter,
    List<Todo> todos,
    String searchTerm,
  ) {
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

    return filteredTodos;
  }

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodosBloc>().state.filteredTodos;

    return MultiBlocListener(
      listeners: [
        BlocListener<TodoListBloc, TodoListState>(
          listener: ((context, state) {
            final filteredTodos = setFilteredTodos(
              context.read<TodoFilterBloc>().state.filter,
              state.todos,
              context.read<TodoSearchBloc>().state.searchTerm,
            );

            context
                .read<FilteredTodosBloc>()
                .add(CalculateFilteredTodosEvent(filteredTodos: filteredTodos));
          }),
        ),
        BlocListener<TodoFilterBloc, TodoFilterState>(
          listener: ((context, state) {
            final filteredTodos = setFilteredTodos(
              state.filter,
              context.read<TodoListBloc>().state.todos,
              context.read<TodoSearchBloc>().state.searchTerm,
            );

            context
                .read<FilteredTodosBloc>()
                .add(CalculateFilteredTodosEvent(filteredTodos: filteredTodos));
          }),
        ),
        BlocListener<TodoSearchBloc, TodoSearchState>(
          listener: ((context, state) {
            final filteredTodos = setFilteredTodos(
                context.read<TodoFilterBloc>().state.filter,
                context.read<TodoListBloc>().state.todos,
                state.searchTerm);

            context
                .read<FilteredTodosBloc>()
                .add(CalculateFilteredTodosEvent(filteredTodos: filteredTodos));
          }),
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
              context
                  .read<TodoListBloc>()
                  .add(RemoveTodoEvent(todo: todos[index]));
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
                            context.read<TodoListBloc>().add(
                                  EditTodoEvent(
                                    id: widget.todo.id,
                                    todoDesc: textController.text,
                                  ),
                                );

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
          context.read<TodoListBloc>().add(
                ToggleTodoEvent(id: widget.todo.id),
              );
        },
      ),
      title: Text(widget.todo.desc),
    );
  }
}
