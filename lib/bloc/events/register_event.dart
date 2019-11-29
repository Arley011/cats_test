
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RegisterEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final String name;
  final String photoUrl;

  const Submitted({
    @required this.email,
    @required this.password,
    this.name = '',
    this.photoUrl = 'https://maxcdn.icons8.com/Share/icon/Users//user_male_circle_filled1600.png',
  });

  @override
  List<Object> get props => [email, password, name, photoUrl];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}