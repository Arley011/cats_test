
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/blocs/cats_bloc.dart';
import '../models/cat.dart';
import '../screens/cat_details_screen.dart';
import '../widgets/favorite_button.dart';

class CatsTile extends StatelessWidget {
  final Cat cat;
  final String email;
  final bool fromFavorites;

  CatsTile({this.cat, this.email, this.fromFavorites = false});

  @override
  Widget build(BuildContext context) {
    //BAD practice, better to wrap to blocbuilder!!!!
    final catBloc = BlocProvider.of<CatsBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(CatDetailsScreen.routeName,
                  arguments: {
                    'cat' : cat,
                    'email': email,
                  });
            },
            child: Hero(
              tag: cat.id,
              child: FadeInImage(
                placeholder: AssetImage(
                  'assets/cat-placeholder.jpg',
                ),
                image: NetworkImage(
                  cat.imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: Container(
            width: 40,
            alignment: Alignment.centerRight,
            child: FavoriteButton(email: email, cat: cat, catsBloc: catBloc,),
          ),
        ),
      ),
    );
  }
}
