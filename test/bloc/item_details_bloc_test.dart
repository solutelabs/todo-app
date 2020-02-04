import 'package:checklist/bloc/item_details/bloc.dart';
import 'package:shared_code/shared_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock_dependencies.dart';

void main() {
  ItemDetailsBloc itemDetailsBloc;
  MockCheckListItemsRepository mockRepo;

  setUp(() {
    mockRepo = MockCheckListItemsRepository();
    itemDetailsBloc = ItemDetailsBloc(
      checklistItemsRepository: mockRepo,
    );
  });

  tearDown(() {
    itemDetailsBloc.close();
  });

  test(('Initial State'), () {
    expectLater(itemDetailsBloc.initialState, InitialItemDetailsState());
  });

  test('Should fetch details and emit ItemsAvailableState with data', () {
    final item = ChecklistItem(id: 'id', description: 'desc');
    when(mockRepo.getItem(any)).thenAnswer((_) => Future.value(item));

    final expected = [
      InitialItemDetailsState(),
      ItemDetailsAvailable(
        title: item.description,
        date: null,
      ),
    ];

    expectLater(itemDetailsBloc, emitsInOrder(expected));

    itemDetailsBloc.add(FetchItemDetails('id'));
  });
}
