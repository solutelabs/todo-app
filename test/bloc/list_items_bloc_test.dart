import 'package:checklist/bloc/list_items/bloc.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock_dependencies.dart';

void main() {
  ListItemsBloc bloc;
  MockItemsProvider mockItemsProvider;
  MockCheckListItemsRepository mockCheckListItemsRepository;

  setUp(() {
    mockCheckListItemsRepository = MockCheckListItemsRepository();
    mockItemsProvider = MockItemsProvider();
    bloc = ListItemsBloc(itemsProvider: mockItemsProvider);
    when(mockItemsProvider.repository).thenReturn(mockCheckListItemsRepository);
  });

  tearDown(() {
    bloc.close();
  });

  test(('Initial State'), () {
    expectLater(bloc.initialState, InitialListItemsState());
  });

  test(
    'Fetch Items should fetch from items prvoider and emit AvailableItemsState',
    () async {
      final expected = [
        InitialListItemsState(),
        AvailableListItems(Stream.value([]))
      ];

      when(mockItemsProvider.watchItems(any)).thenAnswer(
        (_) => Stream.value([]),
      );

      bloc.add(FetchListItems(ListMode.all));
      await expectLater(bloc, emitsInOrder(expected));
      verify(mockItemsProvider.watchItems(any));
      verify(mockCheckListItemsRepository.syncItemsFromServer());
    },
  );

  test('Toggle status should not emmit new state', () async {
    final expected = [
      InitialListItemsState(),
    ];

    bloc.add(
      ToggleCompletionStatus(
        ChecklistItem(id: 'id', description: 'data'),
      ),
    );

    await expectLater(bloc, emitsInOrder(expected));
    verify(
      mockCheckListItemsRepository.update(
        id: 'id',
        isCompleted: true,
      ),
    );
  });
}
