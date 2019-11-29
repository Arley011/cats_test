import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cats_repository.dart';
import '../bloc/login_BLOC.dart';
import '../widgets/login_form.dart';

import '../user_repository.dart';

class LoginScreen extends StatelessWidget {

  final UserRepository _userRepository;
  final CatsRepository _catsRepository;

  LoginScreen(
      {Key key,
        @required UserRepository userRepository,
        @required CatsRepository catsRepository})
      : assert(userRepository != null, catsRepository != null),
        _userRepository = userRepository,
        _catsRepository = catsRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: BlocProvider<LoginBloc>(
          builder: (context) => LoginBloc(userRepository: _userRepository, catsRepository: _catsRepository),
          child: LoginForm(userRepository: _userRepository, catsRepository: _catsRepository,),
        ),
      ),
    );
  }
}
