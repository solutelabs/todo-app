import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/utils/datetime_utils.dart';
import 'package:checklist/view_models/list_items_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCheckListItemsRepository extends Mock
    implements ChecklistItemsRepository {}

void main() {
  final mockRepo = MockCheckListItemsRepository();
  ListItemsViewModel viewModel;

  setUp(() {
    when(
      mockRepo.getItemsInDateRange(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      ),
    ).thenAnswer((_) => Stream.value(dummyItems));

    when(mockRepo.getAllItems()).thenAnswer((_) => Stream.value(dummyItems));
    viewModel = ListItemsViewModel(repository: mockRepo, mode: ListMode.today);
  });

  group('Checklist items by Mode', () {
    test(
        "Get Today's checklist item should emit value and proper method shoud called to repo",
        () {
      expectLater(viewModel.onModeChanged(ListMode.today), emits(dummyItems));
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
      expectLater(
          viewModel.onModeChanged(ListMode.thisWeek), emits(dummyItems));
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
      expectLater(
          viewModel.onModeChanged(ListMode.thisMonth), emits(dummyItems));
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
      expectLater(viewModel.onModeChanged(ListMode.all), emits(dummyItems));
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
