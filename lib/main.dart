import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_app/blocs/blocs.dart';
import 'package:simple_todo_app/models/todo_model.dart';
import 'package:simple_todo_app/pages/todos_page/todos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // We will inject the Global Bloc
    // (From React? Think this as a Context)
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoFilterBloc>(
          create: (context) => TodoFilterBloc(),
        ),
        BlocProvider<TodoSearchBloc>(
          create: (context) => TodoSearchBloc(),
        ),
        BlocProvider<TodoListBloc>(
          create: (context) => TodoListBloc(),
        ),
        BlocProvider<ActiveTodoCountBloc>(
          create: (context) => ActiveTodoCountBloc(
            initialActiveTodoCount: context
                .read<TodoListBloc>()
                .state
                .todos
                .where((Todo todo) => !todo.completed)
                .toList()
                .length,
          ),
        ),
        BlocProvider<FilteredTodosBloc>(
          create: (context) => FilteredTodosBloc(
            initialTodos: context.read<TodoListBloc>().state.todos,
          ),
        ),
      ],
      child: MaterialApp(
        title: "Todo App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TodosPage(),
      ),
    );
  }
}
