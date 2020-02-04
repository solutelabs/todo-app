import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shared_code/shared_code.dart';
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
    ].map(modeToDashboardItems);

    yield AvailableDashBoardItems(Observable.combineLatestList(streams));
  }

  Stream<DashboardItem> modeToDashboardItems(ListMode mode) {
    return itemsProvider.watchItems(mode).map(
          (items) => generateItem(
            items: items,
            mode: mode,
          ),
        );
  }

  DashboardItem generateItem({
    @required ListMode mode,
    @required List<ChecklistItem> items,
  }) {
    return DashboardItem(
      mode: mode,
      title: items.where((item) => !item.isCompleted).length.toString(),
      subtitle: itemsProvider.modeUtils.getTitle(mode),
    );
  }
}
