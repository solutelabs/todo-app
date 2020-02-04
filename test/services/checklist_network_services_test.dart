import 'package:checklist/constants.dart';
import 'package:shared_code/shared_code.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/services/checklist_network_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock_dependencies.dart';

main() {
  final mockDio = MockDioClient();
  final mockUserId = "user_id_123";
  final service = CheckListNetworkServices(
    dioClient: mockDio,
  );

  test(
    'Checklist item should be created with proper URL on server',
    () async {
      when(mockDio.patch(any))
          .thenAnswer((_) => Future.value(Response(statusCode: 200)));

      final checkListItem = ChecklistItem(
        id: '12',
        description: 'TITLE',
      );
      await service.createOrUpdateItem(
        item: checkListItem,
        userId: mockUserId,
      );
      final targetUrl =
          "${APIEndPoints.todoAppBaseUrl}/$mockUserId/todos/${checkListItem.id}.json";

      verify(mockDio.patch(targetUrl, data: checkListItem.toJson()));
    },
  );

  test(
    'If server gives any error, ItemNotCreated exception should thrown',
    () async {
      when(mockDio.patch(any, data: anyNamed('data')))
          .thenThrow((_) => DioError());
      final checkListItem = ChecklistItem(
        id: '12',
        description: 'TITLE',
      );
      await expectLater(
        () => service.createOrUpdateItem(
          item: checkListItem,
          userId: mockUserId,
        ),
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
    await service.getAllItemsForUser(mockUserId);
    final targetUrl = "${APIEndPoints.todoAppBaseUrl}/$mockUserId/todos.json";
    verify(mockDio.get(targetUrl));
  });

  test('All items should be returned in a List', () async {
    when(mockDio.get(any))
        .thenAnswer((_) => Future.value(Response(data: itemsResponse)));
    final list = await service.getAllItemsForUser(mockUserId);
    expect(list.length, 3);
  });

  test('Return empty list, if server throws any error', () async {
    when(mockDio.get(any)).thenThrow((_) => DioError());
    final list = await service.getAllItemsForUser(mockUserId);
    expect(list.length, 0);
  });

  test('Delete request should made on proper URL', () async {
    final checkListItem = ChecklistItem(
      id: '12',
      description: 'TITLE',
    );
    await service.deleteItem(
      itemId: checkListItem.id,
      userId: mockUserId,
    );
    final targetUrl =
        "${APIEndPoints.todoAppBaseUrl}/$mockUserId/todos/${checkListItem.id}.json";
    verify(mockDio.delete(targetUrl));
  });
}
