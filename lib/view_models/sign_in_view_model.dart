import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/utils/string_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class SignInViewModel {
  final AuthRepository authRepository;

  final email = BehaviorSubject<String>();
  final password = BehaviorSubject<String>();
  final onTapContinue = PublishSubject<void>();
  final showProgress = BehaviorSubject<bool>.seeded(false);
  final isFormValid = BehaviorSubject<bool>.seeded(false);
  final showMessage = BehaviorSubject<String>();
  final navigateToHome = PublishSubject<void>();

  final subscription = CompositeSubscription();

  SignInViewModel({@required this.authRepository}) {
    subscription.add(
      onTapContinue
          .throttleTime(Duration(milliseconds: 200))
          .listen((_) => signIn()),
    );

    subscription.add(
      Observable.combineLatest2(
              email,
              password,
              (String email, String password) =>
                  isEmailValid(email) && password.isNotEmpty)
          .listen(isFormValid.add),
    );

    authRepository.getToken().then((token) {
      if (token != null) {
        navigateToHome.add(null);
      }
    });
  }

  Future<void> signIn() async {
    showProgress.add(true);
    try {
      await authRepository.authenticateAndRetrieveToken(
        email: email.value,
        password: password.value,
      );
      navigateToHome.add(null);
    } on InvalidCredentials catch (_) {
      showMessage.add("Invalid Password!");
    } catch (_) {
      showMessage.add("Failed to Sign-in!");
    }
    showProgress.add(false);
  }

  void dispose() {
    email.close();
    password.close();
    onTapContinue.close();
    isFormValid.close();
    showMessage.close();
    showProgress.close();
    navigateToHome.close();
    subscription.dispose();
  }
}
