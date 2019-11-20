import 'package:checklist/bloc/account_manage/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock_dependencies.dart';

void main() {
  AccountManageBloc bloc;
  MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    bloc = AccountManageBloc(mockAuthRepository);
  });

  tearDown(() {
    bloc.close();
  });

  test(('Initial State'), () {
    expectLater(bloc.initialState, LoggedInState());
  });

  test(
    'OnTapLogout event should logout from repo and emit Loggedout state',
    () async {
      final expected = [LoggedInState(), LoggedOutState()];

      bloc.add(OnTapLogout());

      await expectLater(bloc, emitsInOrder(expected));
      verify(mockAuthRepository.logout());
    },
  );
}
