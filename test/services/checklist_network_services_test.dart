import 'package:checklist/constants.dart';
import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/services/checklist_network_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDioClient extends Mock implements Dio {}

class MockAuthRepo extends Mock implements AuthRepository {}

main() {
  final mockDio = MockDioClient();
  final mockAuthRepo = MockAuthRepo();
  final service = ToDoNetworkServices(
    dioClient: mockDio,
    authRepository: mockAuthRepo,
  );

  test(
    'Checklist item should be created with proper URL on server',
    () async {
      when(mockDio.patch(any))
          .thenAnswer((_) => Future.value(Response(statusCode: 200)));
      when(mockAuthRepo.getUserId()).thenAnswer((_) => Future.value('user'));
      final checkListItem = ChecklistItem(
        id: '12',
        description: 'TITLE',
      );
      await service.createOrUpdateCheckListItem(checkListItem);
      final targetUrl =
          "${APIEndPoints.todoAppBaseUrl}/${await mockAuthRepo.getUserId()}/todos/${checkListItem.id}.json";

      verify(mockDio.patch(targetUrl, data: checkListItem.toJson()));
    },
  );

  test(
    'If server gives any error, ItemNotCreated exception should thrown',
    () async {
      when(mockDio.patch(any, data: anyNamed('data')))
          .thenThrow((_) => DioError());
      when(mockAuthRepo.getUserId()).thenAnswer((_) => Future.value('user'));
      final checkListItem = ChecklistItem(
        id: '12',
        description: 'TITLE',
      );
      await expectLater(
        () => service.createOrUpdateCheckListItem(checkListItem),
        throwsA(
          predicate((e) => e is ItemNotCreated),
        ),
      );
    },
  );

  final itemsResponse = {
    "id": {
      "id": "id",
      "description": "description",
      "target_date": null,
      "is_completed": true
    },
    "id2": {
      "id": "id2",
      "description": "description",
      "target_date": "2019-10-30T16:49:58.675",
      "is_completed": true
    },
    "id3": {
      "id": "id3",
      "description": "description",
      "target_date": "2019-10-30T16:49:58.675",
      "is_completed": false
    }
  };

  test('Request should be made on proper URL to get items', () async {
    when(mockDio.get(any))
        .thenAnswer((_) => Future.value(Response(data: itemsResponse)));
    when(mockAuthRepo.getUserId()).thenAnswer((_) => Future.value('user'));
    await service.getAllItemsForCurrentUser();
    final targetUrl = "${APIEndPoints.todoAppBaseUrl}/user/todos.json";
    verify(mockDio.get(targetUrl));
  });

  test('All items should be returned in a List', () async {
    when(mockDio.get(any))
        .thenAnswer((_) => Future.value(Response(data: itemsResponse)));
    when(mockAuthRepo.getUserId()).thenAnswer((_) => Future.value('user'));
    final list = await service.getAllItemsForCurrentUser();
    expect(list.length, 3);
  });

  test('Return empty list, if server throws any error', () async {
    when(mockDio.get(any)).thenThrow((_) => DioError());
    when(mockAuthRepo.getUserId()).thenAnswer((_) => Future.value('user'));
    final list = await service.getAllItemsForCurrentUser();
    expect(list.length, 0);
  });
}
