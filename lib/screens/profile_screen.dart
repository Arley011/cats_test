import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication_BLOC.dart';
import '../bloc/blocs/cats_bloc.dart';
import '../bloc/events/cats_events.dart';

class ProfileScreen extends StatelessWidget {
  final CatsBloc catsBloc;

  ProfileScreen({this.catsBloc});

  static const routeName = '/profile-screen';

  @override
  Widget build(BuildContext context) {
    //this may cause memory leak. better to pass by constructor like the catsBloc!!!
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    final user = authBloc.user;
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
                    user['photo'],
                  ),
            radius: 100,
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            'Name',
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(height: 5,),
          Text(
            user['name'],
            style: TextStyle(fontSize: 24),

          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'E-mail',
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(height: 5,),
          Text(
            user['email'],
            style: TextStyle(fontSize: 24),
          ),
          Spacer(),
          RaisedButton.icon(
            onPressed: () {
              authBloc.add(LoggedOut());
              catsBloc.add(ClearCats());
            },
            icon: Icon(Icons.highlight_off),
            label: Text('Logout'),
            elevation: 0,
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    ));
  }
}
