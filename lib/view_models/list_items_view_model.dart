import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:checklist/providers/items_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class ListItemsViewModel {
  final ItemsProvider itemsProvider;
  BehaviorSubject<ListMode> currentMode;
  final items = BehaviorSubject<List<ChecklistItem>>.seeded([]);

  final _subscriptions = CompositeSubscription();

  ListItemsViewModel({
    @required this.itemsProvider,
    @required ListMode mode,
  }) {
    currentMode = BehaviorSubject<ListMode>.seeded(mode);

    _subscriptions.add(
      currentMode.switchMap(itemsProvider.watchItems).listen(
            items.add,
            onError: (err) => debugPrint(err.toString()),
          ),
    );
  }

  void dispose() {
    currentMode.close();
    items.close();
    _subscriptions.dispose();
  }
}
