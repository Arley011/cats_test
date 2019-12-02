import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cats_repository.dart';

import '../bloc/register_BLOC.dart';
import '../user_repository.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;
  final CatsRepository _catsRepository;

  RegisterScreen(
      {Key key,
      @required UserRepository userRepository,
      @required CatsRepository catsRepository})
      : assert(userRepository != null, catsRepository != null),
        _userRepository = userRepository,
        _catsRepository = catsRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository,catsRepository: _catsRepository),
          child: RegisterForm(),
        ),
      ),
    );
  }
}
