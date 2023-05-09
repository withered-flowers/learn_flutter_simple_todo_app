import 'package:flutter/material.dart';
import 'package:simple_todo_app/pages/todos_page/create_todo.dart';
import 'package:simple_todo_app/pages/todos_page/search_and_filter_todo.dart';
import 'package:simple_todo_app/pages/todos_page/show_todos.dart';
import 'package:simple_todo_app/pages/todos_page/todo_header.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 48.0,
            ),
            child: Column(
              children: <Widget>[
                const TodoHeader(),
                const CreateTodo(),
                const SizedBox(
                  height: 24.0,
                ),
                SearchAndFilterTodo(),
                const ShowTodos(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
