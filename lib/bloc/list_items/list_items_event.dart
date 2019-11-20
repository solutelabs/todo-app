import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/models/list_mode.dart';

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
