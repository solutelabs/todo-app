import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ChecklistItemsRepository repo;

  setUpAll(() {
    repo = ChecklistItemsRepository();
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
    test("NULL Description", () async {
      expectLater(() => repo.insert(descritpion: null),
          throwsA(predicate((e) => e is InvalidUpdateArgumentsException)));
    }, skip: true);

    test("Valid Description", () async {
      final item = await repo.insert(descritpion: "Description of ToDo");
      expect(item.description, "Description of ToDo");
    });

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
    test(
        "Update item with NULL id should throw InvalidUpdateArgumentsException",
        () {
      expectLater(() => repo.update(id: null, descritpion: updatedDesc),
          throwsA(predicate((e) => e is InvalidUpdateArgumentsException)));
    }, skip: true);

    test("Updating non existed item should throw ItemNotFoundException", () {
      expectLater(
          () => repo.update(
                id: "ID which not available",
                descritpion: updatedDesc,
              ),
          throwsA(predicate((e) => e is ItemNotFoundException)));
    }, skip: true);

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
