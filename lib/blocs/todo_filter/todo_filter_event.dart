part of 'todo_filter_bloc.dart';

abstract class TodoFilterEvent extends Equatable {
  const TodoFilterEvent();

  @override
  List<Object> get props => [];
}

// Create new Event based on TodoFilterEvent
// Since this TodoFilterEvent based on Filter onChange
// And the Event is only for that occasion
// We will name it ChangeFilterEvent
class ChangeFilterEvent extends TodoFilterEvent {
  final Filter newFilter;

  const ChangeFilterEvent({
    required this.newFilter,
  });

  @override
  String toString() => 'ChangeFilterEvent(newFilter: $newFilter)';

  @override
  List<Object> get props => [newFilter];
}
