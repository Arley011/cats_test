import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../models/cat.dart';

abstract class CatsEvent extends Equatable{}

class Fetch extends CatsEvent{
  final String email;
  Fetch({this.email});
  @override
  String toString() => 'Fetch';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ClearCats extends CatsEvent{
  final String email;
  ClearCats({this.email});

  @override
  // TODO: implement props
  List<Object> get props => [email];
}

class UploadNew extends CatsEvent{
  final String email;
  UploadNew({this.email});

  @override
  // TODO: implement props
  List<Object> get props => [email];
}

class ToggleFavorite extends CatsEvent {
  final String email;
  final Cat cat;

  ToggleFavorite({@required this.email, @required this.cat});
  @override
  List<Object> get props => [email, cat];

  @override
  String toString() => 'ToggleFavorite';
}
