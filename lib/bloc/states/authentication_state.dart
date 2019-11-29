import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String displayName;
  final String email;
  final String photoUrl;

  const Authenticated(
      {this.displayName,
      this.email,
      this.photoUrl =
          'https://maxcdn.icons8.com/Share/icon/Users//user_male_circle_filled1600.png'});

  Map<String, String> getUser() {
    return {'name': displayName, 'email': email, 'photo': photoUrl};
  }

  @override
  List<Object> get props => [displayName];

  @override
  String toString() => 'Authenticated { displayName: $displayName }';
}

class Unauthenticated extends AuthenticationState {}
