import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/view_models/item_details_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../repositories/mocks/mock_check_list_items_repository.dart';

void main() {
  MockCheckListItemsRepository mockRepo;

  setUp(() {
    mockRepo = MockCheckListItemsRepository();
  });

  test('View Model does not have details for unavailable item', () {
    final viewModel = ItemDetailsViewModel(
      itemId: '1',
      repository: mockRepo,
    );

    expect(viewModel.title.value, isNull);
    expect(viewModel.date.value, isNull);
  });

  test('View Model has correct details for available item', () {
    final testDate = DateTime(2020, 01, 01);
    final testItem = ChecklistItem(
      id: '1',
      description: 'test',
      targetDate: testDate,
    );
    when(mockRepo.getItem('1')).thenAnswer((_) => Future.value(testItem));

    final viewModel = ItemDetailsViewModel(
      itemId: '1',
      repository: mockRepo,
    );

    expect(viewModel.title, emits('test'));
    expect(viewModel.date, emits('01/01/2020'));
  });
}
