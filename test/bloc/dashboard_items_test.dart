import 'package:checklist/bloc/dashboard_items/bloc.dart';
import 'package:shared_code/shared_code.dart';
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
    () async {
      final expected = [
        InitialDashboardItemsState(),
        AvailableDashBoardItems(Stream.value([]))
      ];

      when(mockItemsProvider.repository)
          .thenReturn(mockCheckListItemsRepository);
      when(mockCheckListItemsRepository.syncItemsFromServer())
          .thenAnswer((_) => Future.value(null));
      when(mockItemsProvider.watchItems(any)).thenAnswer(
        (_) => Stream.value([ChecklistItem(id: 'null', description: 'null')]),
      );

      bloc.add(FetchDashBoardItems());
      await expectLater(bloc, emitsInOrder(expected));
      verify(mockItemsProvider.watchItems(ListMode.all));
      verify(mockItemsProvider.watchItems(ListMode.today));
      verify(mockItemsProvider.watchItems(ListMode.thisWeek));
      verify(mockItemsProvider.watchItems(ListMode.thisMonth));
    },
  );

  test('Passing mode should return appropriate dashboard item', () {
    when(mockItemsProvider.repository).thenReturn(mockCheckListItemsRepository);
    when(mockItemsProvider.watchItems(any)).thenAnswer(
      (_) => Stream.value([ChecklistItem(id: 'null', description: 'null')]),
    );
    when(mockItemsProvider.modeUtils).thenReturn(ListModeUtils());

    expectLater(
      bloc.modeToDashboardItems(ListMode.all),
      emitsInOrder(
          [DashboardItem(title: "1", subtitle: "All", mode: ListMode.all)]),
    );
  });

  test('Dashboard items title should only consider in-complete items', () {
    when(mockItemsProvider.repository).thenReturn(mockCheckListItemsRepository);
    when(mockItemsProvider.watchItems(any)).thenAnswer(
      (_) => Stream.value(
          [ChecklistItem(id: '1', description: 'null', isCompleted: true)]),
    );
    when(mockItemsProvider.modeUtils).thenReturn(ListModeUtils());

    expectLater(
      bloc.modeToDashboardItems(ListMode.all),
      emitsInOrder(
          [DashboardItem(title: "0", subtitle: "All", mode: ListMode.all)]),
    );
  });

  test('Generate Item should create models for Dashboard', () {
    when(mockItemsProvider.modeUtils).thenReturn(ListModeUtils());

    final dummyItem = ChecklistItem(id: 'id', description: 'dec');
    final expectedDashBordItem = DashboardItem(
      title: '1',
      subtitle: 'All',
      mode: ListMode.all,
    );
    final dashBordItem = bloc.generateItem(
      mode: ListMode.all,
      items: [dummyItem],
    );
    expect(dashBordItem, expectedDashBordItem);
  });
}
