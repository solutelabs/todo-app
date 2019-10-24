import 'package:checklist/mixins/ui_traits_mixin.dart';
import 'package:checklist/pages/home/home_page.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:checklist/ui_components/snack_message_widget.dart';
import 'package:checklist/utils/network_utils.dart';
import 'package:checklist/view_models/sign_in_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (context) => SignInViewModel(
        authRepository: AuthRepository(
          services: AuthServices(
            dioClient: dioInstance,
          ),
        ),
      ),
      child: _Body(),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SignInViewModel>(context).navigateToHome.listen((_) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeName, (_) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignInViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: viewModel.email.add,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  obscureText: true,
                  onChanged: viewModel.password.add,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                StreamBuilder<bool>(
                  stream: viewModel.isFormValid,
                  initialData: false,
                  builder: (context, snapshot) {
                    return RaisedButton(
                      child: StreamBuilder<bool>(
                        stream: viewModel.showProgress,
                        initialData: false,
                        builder: (context, snapshot) {
                          if (snapshot.data) {
                            return SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text('Continue');
                        },
                      ),
                      onPressed: !snapshot.data
                          ? null
                          : () {
                              if (viewModel.showProgress.value == false) {
                                viewModel.onTapContinue.add(null);
                              }
                            },
                    );
                  },
                ),
                Text(
                  'New User? Enter credentials and we will create an account for you.',
                  textAlign: TextAlign.center,
                ),
                SnackMessageWidget(messageStream: viewModel.showMessage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
