import 'package:checklist/daos/checklist_items_dao.dart';
import 'package:shared_code/shared_code.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> arrange(ChecklistItemsDAO dao) async {
    for (final item in dummyItems) {
      try {
        await dao.insert(item: item);
      } catch (_) {}
    }
  }

  group('Get Item By Id', () {
    test('Passing valid Id should return proper Item', () async {
      final dao = ChecklistItemsDAO();
      await arrange(dao);
      final item = await dao.getItem("6");
      expect(item.description, equals("six"));
    });

    test(
      'Passing Invalid Id should throw ItemNotFoundException Exception',
      () async {
        final dao = ChecklistItemsDAO();
        await arrange(dao);
        expectLater(() => dao.getItem("999"),
            throwsA(predicate((e) => e is ItemNotFoundException)));
      },
    );

    test(
      'Passing NULL Id should throw ItemNotFoundException Exception',
      () async {
        final dao = ChecklistItemsDAO();
        await arrange(dao);
        expectLater(() => dao.getItem(null),
            throwsA(predicate((e) => e is ItemNotFoundException)));
      },
    );
  });

  group(('Get All Items'), () {
    test('Should emit all the items', () async {
      final dao = ChecklistItemsDAO();
      await arrange(dao);
      final streamOfItems = dao.getAllItems();
      expect(streamOfItems, emits(dummyItems));
    });
  });

  group(('Unscheduled Items'), () {
    test('Should emit all unscheduled items', () async {
      final dao = ChecklistItemsDAO();
      await arrange(dao);
      final streamOfItems = dao.getUnscheduledItems();
      expect(streamOfItems, emits(unScheduled));
    });

    test('Should emit empty list if unscheduled items are zero', () async {
      final dao = ChecklistItemsDAO();
      final streamOfItems = dao.getUnscheduledItems();
      expect(streamOfItems, emits([]));
    });
  });

  group(('Items in Range'), () {
    test('Should emit all items which has Target date', () async {
      final dao = ChecklistItemsDAO();
      await arrange(dao);
      final now = DateTime.now();
      final streamOfItems = dao.getItemsInDateRange(
        startDate: DateTime(now.year, now.month, now.day - 1),
        endDate: DateTime.now(),
      );
      expect(streamOfItems, emits(scheduled));
    });

    test('Should emit empty list if scheduled items are zero', () async {
      final dao = ChecklistItemsDAO();
      final now = DateTime.now();
      final streamOfItems = dao.getItemsInDateRange(
        startDate: DateTime(now.year, now.month, now.day),
        endDate: DateTime.now(),
      );
      expect(streamOfItems, emits([]));
    });

    test('Case: Future items', () async {
      final dao = ChecklistItemsDAO();
      await arrange(dao);
      final streamOfItems = dao.getItemsInDateRange(
        startDate: DateTime.now().add(Duration(days: 2)),
        endDate: DateTime.now().add(Duration(days: 3)),
      );
      expect(streamOfItems, emits(futureSchedules));
    });

    test('When End date is less then Start date it should emit zero items',
        () async {
      final dao = ChecklistItemsDAO();
      await arrange(dao);
      final streamOfItems = dao.getItemsInDateRange(
        startDate: DateTime.now().add(Duration(days: 2)),
        endDate: DateTime.now(),
      );
      expect(streamOfItems, emits([]));
    });
  });

  group('Insert new items', () {
    test(
      'New inserted item should be available while getting all items',
      () async {
        final dao = ChecklistItemsDAO();
        final item = ChecklistItem(id: "56", description: "Test");
        await dao.insert(item: item);
        expect(dao.getAllItems(), emits([item]));
      },
    );

    test(
      'New Item with existing id should not be inserted',
      () async {
        final dao = ChecklistItemsDAO();
        final item = ChecklistItem(id: "56", description: "Test");
        await dao.insert(item: item);
        expectLater(() => dao.insert(item: item),
            throwsA(predicate((e) => e is ItemAlreadyExist)));
      },
    );
  });

  group('Update items', () {
    test(
      "Updating Item which doesn't exist should throw ItemNotFoundException",
      () async {
        final dao = ChecklistItemsDAO();
        expectLater(
            () => dao.update(
                  item: ChecklistItem(
                    id: 'THIS IS NOT AVAILABLE',
                    description: "TESTING",
                  ),
                ),
            throwsA(predicate((e) => e is ItemNotFoundException)));
      },
    );

    test(
      'Provided Properities should be updated',
      () async {
        final dao = ChecklistItemsDAO();
        await arrange(dao);
        final updatedItem = ChecklistItem(
          id: "1",
          description: "TEST ITEM ONE",
          isCompleted: true,
        );
        await dao.update(item: updatedItem);
        final item = await dao.getItem("1");
        expect(item.description, equals("TEST ITEM ONE"));
        expect(item.isCompleted, equals(true));
      },
    );

    test(
      'Updating item should not add new item',
      () async {
        final dao = ChecklistItemsDAO();
        await arrange(dao);
        final updatedItem =
            ChecklistItem(id: "1", description: "TEST ITEM ONE");
        await dao.update(item: updatedItem);
        expect(
          dao.getAllItems(),
          emits(
            predicate((items) => items.length == dummyItems.length),
          ),
        );
      },
    );
  });

  group('Delete Items', () {
    test('Deleting Item should not be retrived', () async {
      final dao = ChecklistItemsDAO();
      await arrange(dao);
      await dao.delete(id: "10");
      expect(dao.getAllItems(), emits([...unScheduled, ...scheduled]));
    });
  });

  test('After dispose we should not be able to insert new items', () async {
    final dao = ChecklistItemsDAO();
    dao.dispose();
    expectLater(
      () => dao.insert(item: ChecklistItem(id: "12", description: "desc")),
      throwsA(
        predicate((e) => e is StateError),
      ),
    );
  });
}

final dummyItems = [
  ...unScheduled,
  ...scheduled,
  ...futureSchedules,
];

final scheduled = [
  ChecklistItem(
    id: "3",
    description: "third",
    targetDate: DateTime.now(),
  ),
  ChecklistItem(
    id: "8",
    description: "e",
    targetDate: DateTime.now(),
  ),
];

final unScheduled = [
  ChecklistItem(id: "1", description: "First"),
  ChecklistItem(id: "2", description: "Second"),
  ChecklistItem(id: "4", description: "f"),
  ChecklistItem(id: "5", description: "five"),
  ChecklistItem(id: "6", description: "six"),
];

final futureSchedules = [
  ChecklistItem(
    id: "10",
    description: "TEN",
    targetDate: DateTime.now().add(Duration(days: 3)),
  ),
];
