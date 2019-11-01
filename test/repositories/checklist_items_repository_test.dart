import 'package:checklist/daos/checklist_items_dao.dart';
import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/services/checklist_network_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDao extends Mock implements ChecklistItemsDAO {}

class MockNetworkService extends Mock implements CheckListNetworkServices {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  ChecklistItemsRepository repo;
  CheckListNetworkServices networkServices;
  MockDao mockDao;
  MockAuthRepository mockAuthRepository;

  setUpAll(() {
    mockDao = MockDao();
    networkServices = MockNetworkService();
    mockAuthRepository = MockAuthRepository();
    repo = ChecklistItemsRepository(
      dao: mockDao,
      networkServices: networkServices,
      authRepository: mockAuthRepository,
    );
    when(mockAuthRepository.getUserId())
        .thenAnswer((_) => Future.value('user_id_123'));
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
    final userId = await mockAuthRepository.getUserId();
    when(networkServices.getAllItemsForUser(userId)).thenAnswer(
      (_) => Future.value([dummyItem]),
    );
    await repo.syncItemsFromServer();
    verify(mockDao.insert(item: dummyItem));

    verify(networkServices.getAllItemsForUser(userId));
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
    verify(
      networkServices.createOrUpdateItem(
        item: anyNamed('item'),
        userId: anyNamed('userId'),
      ),
    );
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
      final userId = await mockAuthRepository.getUserId();
      verify(networkServices.createOrUpdateItem(
        item: updatedItem,
        userId: userId,
      ));
    });

    test('If args is not provided while update, old value should persist',
        () async {
      final item = ChecklistItem(id: "1", description: 'data');
      when(mockDao.getItem("1")).thenAnswer((_) => Future.value(item));

      final updatedItem = await repo.update(id: "1", isCompleted: true);

      expect(updatedItem.description, equals("data"));
      verify(mockDao.update(item: updatedItem));
      final userId = await mockAuthRepository.getUserId();
      verify(networkServices.createOrUpdateItem(
        item: updatedItem,
        userId: userId,
      ));
    });
  });

  test('Delete item method should call respective dao method', () async {
    await repo.delete(id: "id");
    verify(mockDao.delete(id: "id"));
    final userId = await mockAuthRepository.getUserId();
    verify(networkServices.deleteItem(
      itemId: "id",
      userId: userId,
    ));
  });

  test('Dispose should delegate to dao level', () {
    repo.dispose();
    verify(mockDao.dispose());
  });
}
