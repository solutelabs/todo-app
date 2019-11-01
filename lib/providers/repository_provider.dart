import 'package:checklist/providers/services_provider.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';

AuthRepository provideAuthRepository() => AuthRepository(
      services: provideAuthService(),
      localStorage: provideLocalStorage(),
    );

ChecklistItemsRepository provideCheckListItemsRepository() =>
    ChecklistItemsRepository(
      dao: provideCheckListDao(),
      networkServices: provideCheckListService(),
      authRepository: provideAuthRepository(),
    );
