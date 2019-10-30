import 'package:checklist/constants.dart';
import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CheckListNetworkServices {
  final Dio dioClient;
  final AuthRepository authRepository;

  CheckListNetworkServices({
    @required this.dioClient,
    @required this.authRepository,
  });

  Future<void> createOrUpdateCheckListItem(ChecklistItem item) async {
    try {
      final url =
          "${APIEndPoints.todoAppBaseUrl}/${await authRepository.getUserId()}/todos/${item.id}.json";
      await dioClient.patch(
        url,
        data: item.toJson(),
      );
    } catch (_) {
      throw ItemNotCreated();
    }
  }

  Future<List<ChecklistItem>> getAllItemsForCurrentUser() async {
    try {
      final response = await dioClient.get(
        "${APIEndPoints.todoAppBaseUrl}/${await authRepository.getUserId()}/todos.json",
      );
      final list = List<Map<String, dynamic>>();
      response.data.forEach((item, value) => list.add(value));
      return list.map((item) => ChecklistItem.fromJson(item)).toList();
    } catch (_) {
      return [];
    }
  }
}
