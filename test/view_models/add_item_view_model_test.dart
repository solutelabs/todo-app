import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/view_models/add_item_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCheckListItemsRepository extends Mock
    implements ChecklistItemsRepository {}

void main() {
  AddItemViewModel viewModel;
  MockCheckListItemsRepository mockRepo;

  setUp(() {
    mockRepo = MockCheckListItemsRepository();
    viewModel = AddItemViewModel(repository: mockRepo);
  });

  group('Validate And Save', () {
    test('Valid description should call repo method with exact args', () async {
      viewModel.description.add('Test Description');
      await viewModel.validateAndSave();
      verify(mockRepo.insert(descritpion: 'Test Description'));
    });

    test(
        'NULL description should emit errors and should not call any method in repo',
        () async {
      viewModel.description.add(null);
      expectLater(viewModel.onError, emits('• Enter description'));
      await viewModel.validateAndSave();
      verifyZeroInteractions(mockRepo);
    });
  });

  group('Validation', () {
    test('Proper description should not return errors', () {
      viewModel.description.add('Test Description');
      final validation = viewModel.validateForm();
      expect(validation['has_errors'], false);
      expect(validation['errors'], []);
    });

    test('NULL description should return errors', () {
      viewModel.description.add(null);
      final validation = viewModel.validateForm();
      expect(validation['has_errors'], true);
      expect(validation['errors'], ['Enter description']);
    });

    test('Empty description should return errors', () {
      viewModel.description.add('  ');
      final validation = viewModel.validateForm();
      expect(validation['has_errors'], true);
      expect(validation['errors'], ['Enter description']);
    });
  });
}
