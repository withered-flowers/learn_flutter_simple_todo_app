import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_app/cubits/cubits.dart';
import 'package:simple_todo_app/cubits/todo_search/todo_search_cubit.dart';
import 'package:simple_todo_app/models/todo_model.dart';

class SearchAndFilterTodo extends StatelessWidget {
  const SearchAndFilterTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            labelText: 'Search todos...',
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (String? newSearchTerm) {
            if (newSearchTerm != null) {
              context.read<TodoSearchCubit>().setSearchTerm(newSearchTerm);
            }
          },
        ),
        SizedBox(
          height: 16.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            filterButton(context, Filter.all),
            filterButton(context, Filter.active),
            filterButton(context, Filter.completed)
          ],
        )
      ],
    );
  }
}

Widget filterButton(BuildContext context, Filter filter) {
  return TextButton(
    onPressed: () {
      context.read<TodoFilterCubit>().changeFilter(filter);
    },
    child: Text(
      filter == Filter.all
          ? 'All'
          : filter == Filter.active
              ? 'Active'
              : 'Completed',
      style: TextStyle(
        fontSize: 16.0,
        color: textColor(context, filter),
      ),
    ),
  );
}

Color textColor(BuildContext context, Filter filter) {
  final currentFilter = context.watch<TodoFilterCubit>().state.filter;
  return currentFilter == filter ? Colors.blue : Colors.grey;
}
