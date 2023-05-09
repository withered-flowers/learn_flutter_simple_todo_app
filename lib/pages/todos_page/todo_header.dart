import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_app/cubits/cubits.dart';

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

        // We will now use BlocBuilder to "watch" the reactive value (state)
        // from ActiveTodoCountState (activeTodoCount)
        // using the BlocBuilder
        BlocBuilder<ActiveTodoCountCubit, ActiveTodoCountState>(
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
