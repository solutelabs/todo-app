import 'package:checklist/daos/checklist_items_dao.dart';
import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/services/checklist_network_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDao extends Mock implements ChecklistItemsDAO {}

class MockNetworkService extends Mock implements CheckListNetworkServices {}

void main() {
  ChecklistItemsRepository repo;
  CheckListNetworkServices networkServices;
  MockDao mockDao;

  setUpAll(() {
    mockDao = MockDao();
    networkServices = MockNetworkService();
    repo = ChecklistItemsRepository(
      dao: mockDao,
      networkServices: networkServices,
    );
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

  test('Items should be fetched from server and store into local dao',
      () async {
    final dummyItem = ChecklistItem(
      id: "1",
      description: "desc",
    );
    when(networkServices.getAllItemsForCurrentUser()).thenAnswer(
      (_) => Future.value([dummyItem]),
    );
    await repo.syncItemsFromServer();
    verify(mockDao.insert(item: dummyItem));
    verify(networkServices.getAllItemsForCurrentUser());
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

    final insertedItem = await repo.insert(description: "data");

    verify(mockDao.insert(item: anyNamed('item')));
    verify(networkServices.createOrUpdateItem(any));
    expect(insertedItem.description, equals('data'));
  });

  group('Update Item', () {
    test(
        'When args validation failed, InvalidUpdateArgumentsException should thrown',
        () {
      expectLater(() => repo.update(id: "12", description: null),
          throwsA(predicate((e) => e is InvalidUpdateArgumentsException)));
    });

    test('Provided args should be updated', () async {
      final item = ChecklistItem(id: "1", description: 'data');
      when(mockDao.getItem("1")).thenAnswer((_) => Future.value(item));

      final updatedItem = await repo.update(id: "1", description: "New Desc");

      expect(updatedItem.description, equals("New Desc"));
      verify(mockDao.update(item: updatedItem));
      verify(networkServices.createOrUpdateItem(updatedItem));
    });

    test('If args is not provided while update, old value should persist',
        () async {
      final item = ChecklistItem(id: "1", description: 'data');
      when(mockDao.getItem("1")).thenAnswer((_) => Future.value(item));

      final updatedItem = await repo.update(id: "1", isCompleted: true);

      expect(updatedItem.description, equals("data"));
      verify(mockDao.update(item: updatedItem));
      verify(networkServices.createOrUpdateItem(updatedItem));
    });
  });

  test('Delete item method should call respective dao method', () {
    repo.delete(id: "id");
    verify(mockDao.delete(id: "id"));
  });
}
