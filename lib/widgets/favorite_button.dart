import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cat.dart';
import '../bloc/cat_BLOC.dart';

class FavoriteButton extends StatelessWidget {
  final String email;
  final Cat cat;

  FavoriteButton({this.email, this.cat});
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<CatsBloc, CatsState>(
      builder: (context, catsState) {
        return IconButton(
          iconSize: 30,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 17),
          icon: Icon(

            //Icons.favorite_border,
            BlocProvider.of<CatsBloc>(context).isFavorite(cat.id) ? Icons.favorite : Icons
                .favorite_border,
          ),
          onPressed: () {
            BlocProvider.of<CatsBloc>(context).add(ToggleFavorite(email: email, cat: cat));
            //do sth
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: BlocProvider.of<CatsBloc>(context).isFavorite(cat.id) ? Text(
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
                    BlocProvider.of<CatsBloc>(context).add(ToggleFavorite(email: email, cat: cat));
                  }),
            ));
          },
          color: Theme
              .of(context)
              .accentColor,
        );
      }
    );
  }
}
