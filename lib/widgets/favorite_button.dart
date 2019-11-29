import 'package:flutter/material.dart';
import '../models/cat.dart';
import '../bloc/cat_BLOC.dart';

class FavoriteButton extends StatelessWidget {
  final String email;
  final CatsBloc catsBloc;
  final Cat cat;

  FavoriteButton({this.catsBloc,this.email, this.cat});
  @override
  Widget build(BuildContext context) {
    return  IconButton(
      iconSize: 30,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 17),
      icon: Icon(

        //Icons.favorite_border,
        catsBloc.isFavorite(cat.id) ? Icons.favorite : Icons.favorite_border,
      ),
      onPressed: () {
        catsBloc.add(ToggleFavorite(email: email, cat: cat));
        //do sth
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: catsBloc.isFavorite(cat.id) ? Text(
            'Kitty removed from favorites!',
            textAlign: TextAlign.center,
          ) : Text(
            'Kitty added to favorites!',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                catsBloc.add(ToggleFavorite(email: email, cat: cat));
              }),
        ));
      },
      color: Theme.of(context).accentColor,
    );
  }
}
