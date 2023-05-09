import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_app/cubits/cubits.dart';
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
            // We will add initialState for activeTodoCount
            initialActiveTodoCount: context
                .read<TodoListCubit>()
                .state
                .todos
                .where((Todo todo) => !todo.completed)
                .toList()
                .length,
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
            // Now we need the initialValue to show
            initialTodos: context.read<TodoListCubit>().state.todos,
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
