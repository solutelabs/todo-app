import 'package:checklist/bloc/add_item/add_item_bloc.dart';
import 'package:checklist/bloc/add_item/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock_dependencies.dart';

void main() {
  AddItemBloc addItemBloc;
  MockCheckListItemsRepository mockCheckListItemsRepository;
  setUp(() {
    mockCheckListItemsRepository = MockCheckListItemsRepository();
    addItemBloc = AddItemBloc(
      checklistItemsRepository: mockCheckListItemsRepository,
    );
  });

  tearDown(() {
    addItemBloc.close();
  });

  test(('Initial State'), () {
    expectLater(addItemBloc.initialState, InitialAddItemState());
  });

  test('Add Description event should emit any new state', () {
    final expected = [
      InitialAddItemState(),
    ];

    expectLater(addItemBloc, emitsInOrder(expected));

    addItemBloc.add(DescriptionAdded('test'));
  });

  test(
    'TargetDateSelected event should emit TargetDateChanged state with formatted date',
    () {
      final date = DateTime(2019, 11, 17);
      final formattedDate = '17/11/2019';

      final expected = [
        InitialAddItemState(),
        TargetDateChanged(formattedDate: formattedDate),
      ];

      expectLater(addItemBloc, emitsInOrder(expected));

      addItemBloc.add(TargetDateSelected(date));
    },
  );

  test(
    'onTapSelect with valid input should emit AddItemSuccess state',
    () {
      final expected = [
        InitialAddItemState(),
        AddItemSuccess(),
      ];

      expectLater(addItemBloc, emitsInOrder(expected));

      addItemBloc.add(DescriptionAdded('desc'));
      addItemBloc.add(OnTapSave());
    },
  );

  test(
    'onTapSelect with invalid input should emit AddItemFailed state',
    () {
      final expected = [
        InitialAddItemState(),
        AddItemFailed(error: '• Enter description'),
      ];

      expectLater(addItemBloc, emitsInOrder(expected));

      addItemBloc.add(OnTapSave());
    },
  );

  test(
    'onTapSelect with input should emit AddItemFailed state if repo gives any error',
    () {
      final expected = [
        InitialAddItemState(),
        AddItemFailed(error: 'Item could not be saved!'),
      ];

      when(
        mockCheckListItemsRepository.insert(
          description: anyNamed('description'),
        ),
      ).thenThrow(
        Exception(),
      );

      expectLater(addItemBloc, emitsInOrder(expected));

      addItemBloc.add(DescriptionAdded('desc'));
      addItemBloc.add(OnTapSave());
    },
  );
}
