import 'package:shared_code/shared_code.dart';
import 'package:equatable/equatable.dart';

abstract class ListItemsState extends Equatable {
  final Stream<List<ChecklistItem>> itemsStream;

  ListItemsState(this.itemsStream);
}

class InitialListItemsState extends ListItemsState {
  InitialListItemsState() : super(Stream.empty());

  @override
  List<Object> get props => [];
}

class AvailableListItems extends ListItemsState {
  AvailableListItems(Stream<List<ChecklistItem>> itemsStream)
      : super(itemsStream);

  @override
  List<Object> get props => [];
}
