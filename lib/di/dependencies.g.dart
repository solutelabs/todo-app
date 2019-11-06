// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// InjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  void configure() {
    final Container container = Container();
    container.registerSingleton((c) => Dio(c<BaseOptions>()));
    container.registerSingleton((c) => ChecklistItemsRepository(
        dao: c<ChecklistItemsDAO>(),
        networkServices: c<CheckListNetworkServices>(),
        authRepository: c<AuthRepository>()));
    container.registerFactory((c) => AuthRepository(
        services: c<AuthServices>(), localStorage: c<LocalStorage>()));
    container.registerFactory((c) => AuthServices(dioClient: c<Dio>()));
    container
        .registerFactory((c) => CheckListNetworkServices(dioClient: c<Dio>()));
    container.registerFactory((c) => ChecklistItemsDAO());
    container.registerFactory(
        (c) => ItemsProvider(repository: c<ChecklistItemsRepository>()));
    container.registerFactory(
        (c) => DashboardItemsViewModel(itemsProvider: c<ItemsProvider>()));
    container.registerFactory(
        (c) => AddItemViewModel(repository: c<ChecklistItemsRepository>()));
    container.registerFactory(
        (c) => AccountManageViewModel(authRepository: c<AuthRepository>()));
  }
}
