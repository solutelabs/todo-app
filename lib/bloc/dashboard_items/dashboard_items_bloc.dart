import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/models/dashboard_item.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:checklist/providers/items_provider.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import './bloc.dart';

class DashboardItemsBloc
    extends Bloc<DashboardItemsEvent, DashboardItemsState> {
  final ItemsProvider itemsProvider;

  DashboardItemsBloc({@required this.itemsProvider});

  @override
  DashboardItemsState get initialState => InitialDashboardItemsState();

  @override
  Stream<DashboardItemsState> mapEventToState(
    DashboardItemsEvent event,
  ) async* {
    if (event is FetchDashBoardItems) {
      itemsProvider.repository.syncItemsFromServer();
      yield* fetchItems();
    }
  }

  Stream<DashboardItemsState> fetchItems() async* {
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

    yield AvailableDashBoardItems(Observable.combineLatestList(streams));
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
