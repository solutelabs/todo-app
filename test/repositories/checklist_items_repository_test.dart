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
  final updatedDesc = "New Desc";
  final date = DateTime.now();
  Future<ChecklistItem> insertDummyItems() {
    return repo.insert(descritpion: "TEST ITEM", targetDate: date);
  }

  group("Item insert", () {
    test("Valid Description", () async {
      final item = await repo.insert(descritpion: "Description of ToDo");
      expect(item.description, "Description of ToDo");
    });

    test("ToDo With Date", () async {
      final date = DateTime.now();
      final item = await repo.insert(
          descritpion: "Description of ToDo", targetDate: date);
      expect(item.targetDate, date);
    });

    test("ToDo with all properities", () async {
      final date = DateTime.now();
      final description = "TEST";
      final item =
          await repo.insert(descritpion: description, targetDate: date);
      expect(item.description, description);
      expect(item.targetDate, date);
    });
  });

  group("Update Item", () {
    setUpAll(() async {
      await insertDummyItems();
    });

    test("Updating non existed item should throw ItemNotFoundException",
        () async {
      when(mockDao.getItem(any)).thenThrow(ItemNotFoundException);
      await expectLater(
          () => repo.update(
                id: "ID which not available",
                descritpion: updatedDesc,
              ),
          throwsA(predicate((e) => e is ItemNotFoundException)));
    });

    test(
      "NULL desciption should throw InvalidUpdateArgumentsException",
      () {
        expectLater(
            () => repo.update(
                  id: "ID which not available",
                  descritpion: null,
                ),
            throwsA(predicate((e) => e is InvalidUpdateArgumentsException)));
      },
    );

    test(
      "Empty desciption should throw InvalidUpdateArgumentsException",
      () {
        expectLater(
            () => repo.update(
                  id: "ID which not available",
                  descritpion: "",
                ),
            throwsA(predicate((e) => e is InvalidUpdateArgumentsException)));
      },
    );

    test(
      "Desciption with blank space should throw InvalidUpdateArgumentsException",
      () {
        expectLater(
            () => repo.update(
                  id: "ID which not available",
                  descritpion: "  ",
                ),
            throwsA(predicate((e) => e is InvalidUpdateArgumentsException)));
      },
    );

    test("Description should be update properly", () async {
      final insertedItem = await insertDummyItems();
      final updatedItem =
          await repo.update(id: insertedItem.id, descritpion: updatedDesc);
      expect(updatedItem.id, insertedItem.id);
      expect(updatedItem.description, updatedDesc);
      expect(updatedItem.targetDate, date);
    });
  });
}
