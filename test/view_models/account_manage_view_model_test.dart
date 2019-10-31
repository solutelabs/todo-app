import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/view_models/account_manage_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

main() {
  MockAuthRepo authRepo;
  AccountManageViewModel viewModel;

  setUp(() {
    authRepo = MockAuthRepo();
    viewModel = AccountManageViewModel(authRepository: authRepo);
  });

  test('Logout should logout from auth repo', () async {
    await viewModel.logout();
    verify(authRepo.logout());
  });
}
