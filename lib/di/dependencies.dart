import 'dart:convert';

import 'package:checklist/daos/checklist_items_dao.dart';
import 'package:checklist/providers/items_provider.dart';
import 'package:checklist/providers/local_storage_provider.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:shared_code/shared_code.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart';
import 'package:localstorage/localstorage.dart' as file_storage;

part 'dependencies.g.dart';

abstract class Injector {
  @Register.singleton(Dio)
  //Repositories
  @Register.singleton(ChecklistItemsRepository)
  @Register.factory(AuthRepository)
  @Register.factory(CheckListNetworkServices)
  @Register.factory(ChecklistItemsDAO)
  @Register.factory(ItemsProvider)
  void configure();
}

void setup() async {
  var injector = _$Injector();

  Container().registerSingleton((c) => BaseOptions());

  final key = await firebaseAPIKey();
  Container().registerFactory(
      (c) => AuthServices(dioClient: c<Dio>(), firebaseApiKey: key));

  Container()
      .registerSingleton((c) => file_storage.LocalStorage('session_data'));

  Container().registerFactory<LocalStorage, FileBasedStorage>(
      (c) => FileBasedStorage(fileStorage: c<file_storage.LocalStorage>()));

  injector.configure();
}

Future<String> firebaseAPIKey() async {
  final configuration =
      await rootBundle.loadString('lib/assets/configuration.json');
  final configurationJson = json.decode(configuration);
  return configurationJson['firebase_key'];
}
