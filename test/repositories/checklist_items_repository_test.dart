import 'package:checklist/daos/checklist_items_dao.dart';
import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDao extends Mock implements ChecklistItemsDAO {}

void main() {
  ChecklistItemsRepository repo;
  MockDao mockDao;

  setUpAll(() {
    mockDao = MockDao();
    repo = ChecklistItemsRepository(mockDao);
  });

  tearDownAll(() {
    repo = null;
  });

  test('Get item method should call respective dao method', () async {
    try {
      await repo.getItem("id");
    } catch (_) {}
    verify(mockDao.getItem("id"));
  });

  test('Get allItems items method should call respective dao method', () {
    repo.getAllItems();
    verify(mockDao.getAllItems());
  });

  test('Get unscheduled items method should call respective dao method', () {
    repo.getUnscheduledItems();
    verify(mockDao.getUnscheduledItems());
  });

  test(
      'Get Items for date range method should call respective dao method with same args',
      () {
    final date = DateTime.now();
    repo.getItemsInDateRange(startDate: date, endDate: date);
    verify(mockDao.getItemsInDateRange(startDate: date, endDate: date));
  });

  test('Item should be created with provided args', () async {
    final item = ChecklistItem(id: "1", description: 'data');
    when(mockDao.insert(item: anyNamed('item')))
        .thenAnswer((_) => Future.value(item));

    final insertedItem = await repo.insert(descritpion: "data");

    verify(mockDao.insert(item: anyNamed('item')));
    expect(insertedItem.description, equals('data'));
  });

  group('Update Item', () {
    test(
        'When args validation failed, InvalidUpdateArgumentsException should thrown',
        () {
      expectLater(() => repo.update(id: "12", descritpion: null),
          throwsA(predicate((e) => e is InvalidUpdateArgumentsException)));
    });

    test('Provided args should be updated', () async {
      final item = ChecklistItem(id: "1", description: 'data');
      when(mockDao.getItem("1")).thenAnswer((_) => Future.value(item));

      final updatedItem = await repo.update(id: "1", descritpion: "New Desc");

      expect(updatedItem.description, equals("New Desc"));
      verify(mockDao.update(item: updatedItem));
    });
  });

  test('Delete item method should call respective dao method', () {
    repo.delete(id: "id");
    verify(mockDao.delete(id: "id"));
  });
}
