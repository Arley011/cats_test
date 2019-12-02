import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import './cats_repository.dart';

import './bloc/authentication_BLOC.dart';
import './bloc/blocs/cats_bloc.dart';
import './bloc/tab_BLOC.dart';
import './screens/cat_details_screen.dart';
import './screens/cats_screen.dart';
import './screens/favorites_screen.dart';
import './screens/login_screen.dart';
import './screens/profile_screen.dart';
import './screens/splash_screen.dart';
import './screens/tabs_screen.dart';
import './simple_bloc_delegate.dart';
import './user_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  final CatsRepository catsRepository = CatsRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: MyApp(
        userRepository: userRepository,
        catsRepository: catsRepository,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  final CatsRepository _catsRepository;

  //why is this a global variable?
  final CatsBloc _catsBloc = CatsBloc(httpClient: http.Client());

  MyApp({Key key, userRepository, catsRepository})
      : assert(userRepository != null, catsRepository != null),
        _userRepository = userRepository,
        _catsRepository = catsRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CatsBloc>(
          create: (_) => _catsBloc,
        ),
        BlocProvider<TabBloc>(
          create: (_) => TabBloc(),
        )
      ],
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state is Uninitialized) {
          return SplashScreen();
        }
        if (state is Unauthenticated) {
          return LoginScreen(
            userRepository: _userRepository, catsRepository: _catsRepository,
          );
        }
        if (state is Authenticated) {
          return MaterialApp(
            title: 'Kitty App',
            theme: ThemeData(
                primarySwatch: Colors.lightGreen,
                accentColor: Colors.cyanAccent,
                textTheme: ThemeData
                    .light()
                    .textTheme
                    .copyWith(
                  title: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                  button: TextStyle(color: Colors.white),
                ),
            ),
            routes: {
              '/': (ctx) => TabsScreen(),
              CatsScreen.routeName: (ctx) => CatsScreen(),
              CatDetailsScreen.routeName: (ctx) => CatDetailsScreen(),
              FavoritesScreen.routeName: (ctx) => FavoritesScreen(),
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
            },
          );
        } else
          return (Center(
            child: (Text('Error')),
          ));
      }),
    );
  }
}
