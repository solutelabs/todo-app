import 'package:shared_code/shared_code.dart';

abstract class ListItemsEvent {
  const ListItemsEvent();
}

class FetchListItems extends ListItemsEvent {
  final ListMode listMode;

  FetchListItems(this.listMode);
}

class ToggleCompletionStatus extends ListItemsEvent {
  final ChecklistItem item;

  ToggleCompletionStatus(this.item);
}
