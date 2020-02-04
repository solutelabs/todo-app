import 'package:shared_code/shared_code.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CheckListNetworkServices {
  final Dio dioClient;

  CheckListNetworkServices({
    @required this.dioClient,
  });

  Future<void> createOrUpdateItem({
    @required ChecklistItem item,
    @required String userId,
  }) async {
    try {
      final url =
          "${APIEndPoints.todoAppBaseUrl}/$userId/todos/${item.id}.json";
      await dioClient.patch(
        url,
        data: item.toJson(),
      );
    } catch (_) {
      throw ItemNotCreated();
    }
  }

  Future<List<ChecklistItem>> getAllItemsForUser(String userId) async {
    try {
      final response = await dioClient.get(
        "${APIEndPoints.todoAppBaseUrl}/$userId/todos.json",
      );
      final list = List<Map<String, dynamic>>();
      response.data.forEach((item, value) => list.add(value));
      return list.map((item) => ChecklistItem.fromJson(item)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> deleteItem({
    @required String itemId,
    @required String userId,
  }) async {
    try {
      final url = "${APIEndPoints.todoAppBaseUrl}/$userId/todos/$itemId.json";
      await dioClient.delete(url);
    } catch (_) {}
  }
}
