import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_demo_cats/bloc/cat_BLOC.dart';
import '../bloc/events/cats_events.dart';

import './cats_screen.dart';
import './favorites_screen.dart';
import './profile_screen.dart';
import '../bloc/authentication_BLOC.dart';
import '../bloc/blocs/cats_bloc.dart';
import '../bloc/tab_BLOC.dart';
import '../models/app_tab.dart';

class TabsScreen extends StatelessWidget {
  static const routeName = '/tabs-screen';

  @override
  Widget build(BuildContext context) {
    final catsBloc = BlocProvider.of<CatsBloc>(context);
    final email = BlocProvider.of<AuthenticationBloc>(context).email;
    catsBloc.add(UploadNew(email: email));
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) => Scaffold(
        appBar: AppBar(
          title: Text('Kitty App'),
        ),
        body: activeTab == AppTab.cats
            ? CatsScreen(
                catsBloc: catsBloc,
                email: email,
              )
            : activeTab == AppTab.favorites
                ? FavoritesScreen(
                    catsBloc: catsBloc,
                    email: email,
                  )
                : ProfileScreen(
                    catsBloc: catsBloc,
                  ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: AppTab.values.indexOf(activeTab),
          onTap: (index) => BlocProvider.of<TabBloc>(context)
              .add(UpdateTab(AppTab.values[index])),
          items: [
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.list),
              title: Text('Cats'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.star),
              title: Text('Favorites'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
