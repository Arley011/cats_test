import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../cats_repository.dart';
import '../../user_repository.dart';
import '../../validators.dart';
import '../register_BLOC.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final _catsRepository;
  final UserRepository _userRepository;

  RegisterBloc(
      {@required UserRepository userRepository,
      @required CatsRepository catsRepository})
      : assert(userRepository != null, catsRepository != null),
        _userRepository = userRepository,
        _catsRepository = catsRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transformEvents(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next,
  ) {
    final observableStream = events as Observable<RegisterEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
        email: event.email,
        password: event.password,
        name: event.name,
        photoUrl: event.photoUrl,
      );
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState({
    String email,
    String password,
    String name,
    String photoUrl,
  }) async* {
    yield RegisterState.loading();
    try {

      await _userRepository.signUp(
        email: email,
        password: password,
        name: name,
        photoUrl: photoUrl
      );
      await _catsRepository.registerUserToFirestore(
        email: email,
        name: name,
        photoUrl: photoUrl,
      );

      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
