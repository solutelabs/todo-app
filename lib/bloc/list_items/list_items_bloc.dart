import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:checklist/providers/items_provider.dart';
import './bloc.dart';

class ListItemsBloc extends Bloc<ListItemsEvent, ListItemsState> {
  final ItemsProvider itemsProvider;

  ListItemsBloc({this.itemsProvider});

  @override
  ListItemsState get initialState => InitialListItemsState();

  @override
  Stream<ListItemsState> mapEventToState(
    ListItemsEvent event,
  ) async* {
    if (event is FetchListItems) {
      itemsProvider.repository.syncItemsFromServer();
      yield AvailableListItems(itemsProvider.watchItems(event.listMode));
    }

    if (event is ToggleCompletionStatus) {
      await itemsProvider.repository.update(
        id: event.item.id,
        isCompleted: !event.item.isCompleted,
      );
    }
  }
}
