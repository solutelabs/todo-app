import 'package:checklist/daos/checklist_items_dao.dart';
import 'package:shared_code/shared_code.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/services/checklist_network_services.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class ChecklistItemsRepository {
  final ChecklistItemsDAO dao;
  final CheckListNetworkServices networkServices;
  final AuthRepository authRepository;

  ChecklistItemsRepository._({
    @required this.dao,
    @required this.networkServices,
    @required this.authRepository,
  });

  static ChecklistItemsRepository _instance;

  factory ChecklistItemsRepository({
    @required ChecklistItemsDAO dao,
    @required CheckListNetworkServices networkServices,
    @required AuthRepository authRepository,
  }) {
    _instance ??= ChecklistItemsRepository._(
      dao: dao,
      networkServices: networkServices,
      authRepository: authRepository,
    );
    return _instance;
  }

  void dispose() {
    dao.dispose();
  }

  Future<ChecklistItem> getItem(String id) {
    return dao.getItem(id);
  }

  Stream<List<ChecklistItem>> getAllItems() {
    return dao.getAllItems();
  }

  Future<void> syncItemsFromServer() async {
    final userId = await authRepository.getUserId();
    final serverItems = await networkServices.getAllItemsForUser(userId);
    serverItems.forEach((item) async {
      try {
        await dao.insert(item: item);
      } catch (_) {}
    });
  }

  Stream<List<ChecklistItem>> getUnscheduledItems() {
    return dao.getUnscheduledItems();
  }

  Stream<List<ChecklistItem>> getItemsInDateRange({
    @required DateTime startDate,
    @required DateTime endDate,
  }) {
    return dao.getItemsInDateRange(startDate: startDate, endDate: endDate);
  }

  Future<ChecklistItem> insert({
    @required String description,
    DateTime targetDate,
  }) async {
    final id = Uuid().v1();
    final item = ChecklistItem(
      id: id,
      description: description,
      targetDate: targetDate,
      isCompleted: false,
    );
    final userId = await authRepository.getUserId();
    final _ = networkServices.createOrUpdateItem(
      item: item,
      userId: userId,
    );
    return dao.insert(item: item);
  }

  Future<ChecklistItem> update({
    @required String id,
    String description,
    DateTime targetDate,
    bool isCompleted,
  }) async {
    if ((description == null || description.isEmpty) &&
        targetDate == null &&
        isCompleted == null) {
      throw InvalidUpdateArgumentsException();
    }
    final item = await dao.getItem(id);
    final updatedItem = ChecklistItem(
      id: id,
      description: description ?? item.description,
      targetDate: targetDate ?? item.targetDate,
      isCompleted: isCompleted ?? item.isCompleted,
    );
    final userId = await authRepository.getUserId();
    final _ = networkServices.createOrUpdateItem(
      item: updatedItem,
      userId: userId,
    );
    await dao.update(item: updatedItem);
    return updatedItem;
  }

  Future<void> delete({@required String id}) async {
    final userId = await authRepository.getUserId();
    final _ = networkServices.deleteItem(
      itemId: id,
      userId: userId,
    );
    return dao.delete(id: id);
  }
}
