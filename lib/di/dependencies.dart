import 'dart:convert';

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

  Container()
      .registerFactory<LocalStorage, InMemoryStorage>((c) => InMemoryStorage());

  injector.configure();
}

Future<String> firebaseAPIKey() async {
  final configuration =
      await rootBundle.loadString('lib/assets/configuration.json');
  final configurationJson = json.decode(configuration);
  return configurationJson['firebase_key'];
}
