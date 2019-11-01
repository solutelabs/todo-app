import 'package:checklist/view_models/account_manage_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock_dependencies.dart';

main() {
  MockAuthRepository authRepo;
  AccountManageViewModel viewModel;

  setUp(() {
    authRepo = MockAuthRepository();
    viewModel = AccountManageViewModel(authRepository: authRepo);
  });

  test('Logout should logout from auth repo', () async {
    await viewModel.logout();
    verify(authRepo.logout());
  });
}
