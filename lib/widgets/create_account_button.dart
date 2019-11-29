import 'package:flutter/material.dart';
import '../cats_repository.dart';
import '../user_repository.dart';
import '../screens/register_screen.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;
  final CatsRepository _catsRepository;

  CreateAccountButton(
      {Key key,
        @required UserRepository userRepository,
        @required CatsRepository catsRepository})
      : assert(userRepository != null, catsRepository != null),
        _userRepository = userRepository,
        _catsRepository = catsRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Create an Account',
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return RegisterScreen(userRepository: _userRepository, catsRepository: _catsRepository,);
          }),
        );
      },
    );
  }
}