import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blocs/cats_bloc.dart';
import '../bloc/states/cats_state.dart';
import '../widgets/cat_tile.dart';

class FavoritesScreen extends StatelessWidget {
  static const routeName = '/favorites-screen';
  final String email;

  FavoritesScreen({Key key, @required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatsBloc, CatsState>(
      builder: (context, catState) {
        if (catState is CatsUninitialized) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (catState is CatsLoaded) {
          if (catState.favs.isEmpty) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text(
                  'No Favorites Yet',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Image.asset(
                    'assets/no-cats.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1),
            itemCount: catState.favs.length,
            itemBuilder: (context, index) {
              return _cats(index, catState);
            },
          );
        } else {
          return Center(child: Text('There was an error'));
        }
      },
    );
  }

  Widget _cats(int i, CatsState catsState) {
    final cat = (catsState as CatsLoaded).favs[i];
    return CatsTile(cat: cat, email: email, fromFavorites: true);
  }
}
