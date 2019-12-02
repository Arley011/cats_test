import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/blocs/cats_bloc.dart';
import '../bloc/cat_BLOC.dart';
import '../widgets/favorite_button.dart';

class CatDetailsScreen extends StatelessWidget {
  static const routeName = '/cat-details';

  @override
  Widget build(BuildContext context) {
    final catData = ModalRoute.of(context).settings.arguments as Map;
    final cat = catData['cat'];
    final email = catData['email'];
    return BlocBuilder<CatsBloc, CatsState>(
      builder: (context, catsState)  {
        if(catsState is CatsLoaded)
        return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Kitty Fact'),
                background: Hero(
                  tag: cat.id,
                  child: Image.network(
                    cat.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              actions: <Widget>[
                FavoriteButton(email: email, cat: cat),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(13),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          cat.fact,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 500,
                ),
              ]),
            ),
          ],
        ),
      );
        else return Center(child: CircularProgressIndicator(),);}
    );
  }
}
