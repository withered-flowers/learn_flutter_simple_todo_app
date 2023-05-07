import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_app/cubits/active_todo_count/active_todo_count_cubit.dart';
import 'package:simple_todo_app/cubits/filtered_todos/filtered_todos_cubit.dart';
import 'package:simple_todo_app/cubits/todo_filter/todo_filter_cubit.dart';
import 'package:simple_todo_app/cubits/todo_list/todo_list_cubit.dart';
import 'package:simple_todo_app/cubits/todo_search/todo_search_cubit.dart';
import 'package:simple_todo_app/pages/todos_page.dart';

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
        BlocProvider<TodoFilterCubit>(
          create: (context) => TodoFilterCubit(),
        ),
        BlocProvider<TodoSearchCubit>(
          create: (context) => TodoSearchCubit(),
        ),
        BlocProvider<TodoListCubit>(
          create: (context) => TodoListCubit(),
        ),
        // This will required a "computed" cubit from TodoListCubit
        BlocProvider<ActiveTodoCountCubit>(
          create: (context) => ActiveTodoCountCubit(
            // We will use the "of" and require Type of TodoListCubit
            todoListCubit: BlocProvider.of<TodoListCubit>(context),
          ),
        ),
        BlocProvider<FilteredTodosCubit>(
          create: (context) => FilteredTodosCubit(
            // We will use the "of" and require Type of TodoFilterCubit
            todoFilterCubit: BlocProvider.of<TodoFilterCubit>(context),
            // We will use the "of" and require Type of TodoSearchCubit
            todoSearchCubit: BlocProvider.of<TodoSearchCubit>(context),
            // We will use the "of" and require Type of TodoListCubit
            todoListCubit: BlocProvider.of<TodoListCubit>(context),
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
