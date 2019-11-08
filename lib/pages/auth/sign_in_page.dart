import 'package:checklist/bloc/login/bloc.dart';
import 'package:checklist/mixins/ui_traits_mixin.dart';
import 'package:checklist/pages/home/home_page.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class SignInPage extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final c = kiwi.Container();
    return BlocProvider<LoginBloc>(
      builder: (context) => LoginBloc(authRepository: c<AuthRepository>())
        ..add(
          CheckActiveSession(),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign in'),
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
  }) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> with UITraitsMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (BuildContext context, state) {
        if (state is LoginLoggedIn) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomePage.routeName, (_) => false);
        }

        if (state is LoginFailed) {
          showMessage(state.error);
        }

        if (state is ResetPasswordFailed) {
          showMessage(state.error);
        }

        if (state is ResetPasswordSuccess) {
          showMessage(
            "We have sent an email with reset password link",
            isError: false,
          );
        }
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (email) => BlocProvider.of<LoginBloc>(context).add(
                    EmailEntered(email),
                  ),
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  obscureText: true,
                  onChanged: (password) =>
                      BlocProvider.of<LoginBloc>(context).add(
                    PasswordEntered(password),
                  ),
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  condition: (_, state) => (state == LoginFormValid() ||
                      state == LoginFormInValid() ||
                      state == LoginLoading()),
                  builder: (BuildContext context, state) {
                    return RaisedButton(
                      onPressed: state == LoginFormInValid()
                          ? null
                          : () => BlocProvider.of<LoginBloc>(context)
                              .add(LoginButtonPressed()),
                      child: state == LoginLoading()
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            )
                          : Text('Continue'),
                    );
                  },
                ),
                Text(
                  'New User? Enter credentials and we will create an account for you.',
                  textAlign: TextAlign.center,
                ),
                Text.rich(
                  TextSpan(
                    text: 'Reset Password',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        BlocProvider.of<LoginBloc>(context)
                            .add(ResetPasswordRequest());
                      },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMessage(String message, {bool isError = true}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }
}
