import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/view_models/sign_in_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRepo extends Mock implements AuthRepository {}

main() {
  final mockRepo = MockRepo();

  SignInViewModel createViewModel() =>
      SignInViewModel(authRepository: mockRepo);

  test('Valid email and non empty password should emmit true to isFormValid',
      () {
    final viewModel = createViewModel();
    viewModel.email.add('milind.mevada@solutelabs.com');
    viewModel.password.add('pass');
    expectLater(viewModel.isFormValid, emitsInOrder([false, true]));
  });

  test('In Valid email should emmit false to isFormValid', () {
    final viewModel = createViewModel();
    viewModel.email.add('milind.mevadasolutelabs.com');
    expectLater(viewModel.isFormValid, emitsInOrder([false]));
  });

  test('Passing invalid credetials should emmit proper error in Show message',
      () {
    when(mockRepo.authenticateAndRetrieveToken(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenThrow(InvalidCredentials());

    final viewModel = createViewModel();
    viewModel.email.add('milind.mevada@solutelabs.com');
    viewModel.password.add('pass');
    viewModel.onTapContinue.add(null);

    expectLater(viewModel.showMessage, emitsInOrder(["Invalid Password!"]));
  });

  test('For other exception, show message should emmit an event', () {
    when(mockRepo.authenticateAndRetrieveToken(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenThrow(Exception());

    final viewModel = createViewModel();
    viewModel.email.add('milind.mevada@solutelabs.com');
    viewModel.password.add('pass');
    viewModel.onTapContinue.add(null);

    expectLater(viewModel.showMessage, emitsInOrder(["Failed to Sign-in!"]));
  });

  test('Passing valid credetials should emmit event for navigate to home', () {
    when(mockRepo.authenticateAndRetrieveToken(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((_) => Future.value('token'));

    final viewModel = createViewModel();
    viewModel.email.add('milind.mevada@solutelabs.com');
    viewModel.password.add('pass');
    viewModel.onTapContinue.add(null);

    expectLater(viewModel.navigateToHome, emitsInOrder([null]));
  });
}
