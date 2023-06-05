import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_app/blocs/blocs.dart';
import 'package:simple_todo_app/models/todo_model.dart';

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'TODO',
          style: TextStyle(
            fontSize: 40,
          ),
        ),

        BlocListener<TodoListBloc, TodoListState>(
          listener: ((context, state) {
            final int activeTodoCount = state.todos
                .where((Todo todo) => !todo.completed)
                .toList()
                .length;

            // Let's dispatch the event
            context.read<ActiveTodoCountBloc>().add(
                  CalculateActiveTodoCountEvent(
                    activeTodoCount: activeTodoCount,
                  ),
                );
          }),
          child: BlocBuilder<ActiveTodoCountBloc, ActiveTodoCountState>(
            builder: (context, state) {
              return Text(
                '${state.activeTodoCount} items left',
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.redAccent,
                ),
              );
            },
          ),
        ),

        // But hey !
        // Since we already declare the MutipleBlocProvider (treat it as context)
        // And on the cubit we already provide the subscription stream
        // Now we can only "watch" the state
        // Text(
        //   '${context.watch<ActiveTodoCountCubit>().state.activeTodoCount} items left',
        //   style: const TextStyle(
        //     fontSize: 24.0,
        //     color: Colors.redAccent,
        //   ),
        // ),
      ],
    );
  }
}
