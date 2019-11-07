import 'package:checklist/bloc/dashboard_items/bloc.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock_dependencies.dart';

void main() {
  DashboardItemsBloc bloc;
  MockItemsProvider mockItemsProvider;
  MockCheckListItemsRepository mockCheckListItemsRepository;

  setUp(() {
    mockCheckListItemsRepository = MockCheckListItemsRepository();
    mockItemsProvider = MockItemsProvider();
    bloc = DashboardItemsBloc(itemsProvider: mockItemsProvider);
  });

  tearDown(() {
    bloc.close();
  });

  test(('Initial State'), () {
    final DashboardItemsState initialState = InitialDashboardItemsState();
    expectLater(bloc.initialState, initialState);
  });

  test(
    'Fetch Items should fetch from items prvoider and emit AvailableItemsState',
    () {
      final dummyItem = ChecklistItem(id: 'id', description: 'dec');

      final expected = [
        InitialDashboardItemsState(),
        AvailableDashBoardItems(Stream.value([]))
      ];

      when(mockItemsProvider.repository)
          .thenReturn(mockCheckListItemsRepository);
      when(mockItemsProvider.watchItems(any)).thenAnswer(
        (_) => Stream.value([dummyItem]),
      );

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(FetchDashBoardItems());
    },
  );
}
