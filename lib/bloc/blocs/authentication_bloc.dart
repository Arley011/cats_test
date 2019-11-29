import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../user_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../authentication_BLOC.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;


  @override
  Stream<AuthenticationState> transformEvents(Stream<AuthenticationEvent> events, Stream<AuthenticationState> Function(AuthenticationEvent event) next) {
    final observableStream = events as Observable<AuthenticationEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is Uninitialized);
    });
    final debouncedStream = observableStream.where((event) {
      return (event is! Uninitialized);
    }).debounceTime(Duration(milliseconds: 1200));
    return super.transformEvents(nonDebounceStream.mergeWith([debouncedStream]), next);
  }

  @override
  AuthenticationState get initialState => Uninitialized();

  Map<String,String> get user{
    final currentState = state;
    if(currentState is Authenticated){
      return currentState.getUser();
    }
    else return null;
  }

  String get email{
    final currentState = state;
    if(currentState is Authenticated){
      return currentState.email;
    }
    else return null;
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser();
        yield Authenticated(displayName: user['name'], email: user['email'], photoUrl: user['photo']);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      final user = await _userRepository.getUser();
      yield Authenticated(displayName: user['name'],
          email: user['email'],
          photoUrl: user['photo']);
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}