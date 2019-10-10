import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/models/dashboard_item.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:checklist/providers/items_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class DashboardItemsViewModel {
  final ItemsProvider itemsProvider;

  final items = BehaviorSubject<List<DashboardItem>>.seeded([]);

  final _subscriptions = CompositeSubscription();

  DashboardItemsViewModel({
    @required this.itemsProvider,
  }) {
    final streams = [
      ListMode.today,
      ListMode.thisWeek,
      ListMode.thisMonth,
      ListMode.all,
    ].map(
      (mode) => itemsProvider.watchItems(mode).map(
            (items) => generateItem(
              items: items,
              mode: mode,
            ),
          ),
    );
    _subscriptions.add(
      Observable.combineLatestList(streams).listen(
        items.add,
        onError: (err) => debugPrint(err.toString()),
      ),
    );
  }

  void dispose() {
    _subscriptions.dispose();
    items.close();
  }

  DashboardItem generateItem({
    @required ListMode mode,
    @required List<ChecklistItem> items,
  }) {
    return DashboardItem(
      mode: mode,
      title: items.length.toString(),
      subtitle: itemsProvider.modeUtils.getTitle(mode),
    );
  }
}
