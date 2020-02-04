import 'package:shared_code/shared_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock_dependencies.dart';

void main() {
  ItemsProvider provider;
  MockCheckListItemsRepository mockRepo;

  setUp(() {
    mockRepo = MockCheckListItemsRepository();
    provider = ItemsProvider(repository: mockRepo);

    when(
      mockRepo.getItemsInDateRange(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      ),
    ).thenAnswer((_) => Stream.value(dummyItems));

    when(mockRepo.getAllItems()).thenAnswer((_) => Stream.value(dummyItems));
  });

  group('Checklist items by Mode', () {
    test(
        "Get Today's checklist item should emit value and proper method shoud called to repo",
        () {
      expectLater(provider.watchItems(ListMode.today), emits(dummyItems));
      verify(
        mockRepo.getItemsInDateRange(
          startDate: DateTimeUtils().startOfDay(DateTime.now()),
          endDate: DateTimeUtils().endOfDay(DateTime.now()),
        ),
      );
    });

    test(
        "Get this week's checklist item should emit value and proper method shoud called to repo",
        () {
      expectLater(provider.watchItems(ListMode.thisWeek), emits(dummyItems));
      verify(
        mockRepo.getItemsInDateRange(
          startDate: DateTimeUtils().startOfWeek(DateTime.now()),
          endDate: DateTimeUtils().endOfWeek(DateTime.now()),
        ),
      );
    });

    test(
        "Get this month's checklist item should emit value and proper method shoud called to repo",
        () {
      expectLater(provider.watchItems(ListMode.thisMonth), emits(dummyItems));
      verify(
        mockRepo.getItemsInDateRange(
          startDate: DateTimeUtils().startOfMonth(DateTime.now()),
          endDate: DateTimeUtils().endOfMonth(DateTime.now()),
        ),
      );
    });

    test(
        "Get all checklist item should emit value and proper method shoud called to repo",
        () {
      expectLater(provider.watchItems(ListMode.all), emits(dummyItems));
      verify(mockRepo.getAllItems());
    });
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
