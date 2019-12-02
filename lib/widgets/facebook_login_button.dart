import 'package:flutter/material.dart';
import '../bloc/login_BLOC.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacebookLoginButton extends StatelessWidget {
  final LoginBloc loginBloc;
  FacebookLoginButton({@required this.loginBloc});
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      icon: Icon(FontAwesomeIcons.facebook, color: Colors.white),
      onPressed: () {
        loginBloc.add(
          LoginWithFacebookPressed(),
        );
      },
      label: Text('Sign in with Facebook', style: TextStyle(color: Colors.white)),
      color: Colors.redAccent,
    );
  }
}