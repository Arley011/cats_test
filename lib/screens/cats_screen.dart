import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blocs/cats_bloc.dart';
import '../bloc/events/cats_events.dart';
import '../bloc/states/cats_state.dart';
import '../widgets/cat_tile.dart';

class CatsScreen extends StatefulWidget {
  static const routeName = '/cats-screen';
  final CatsBloc catsBloc;
  final String email;

  CatsScreen({Key key, @required this.catsBloc, @required this.email})
      : super(key: key);

  @override
  _CatsScreenState createState() => _CatsScreenState();
}

class _CatsScreenState extends State<CatsScreen> {
  final _scrollThreshold = 200.0;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      widget.catsBloc.add(Fetch(email: widget.email));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatsBloc, CatsState>(
      bloc: widget.catsBloc,
      builder: (context, catState) {
        if (catState is CatsUninitialized) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (catState is CatsLoaded) {
          if (catState.cats.isEmpty) {
            return Center(child: Text('There was an error'));
          }
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (c, i) => _cats(i, catState),
                  childCount: catState.cats.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
              ),
              SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        } else {
          return Center(child: Text('There was an error'));
        }
      },
    );
  }

  Widget _cats(int i, CatsState catsState) {
    final cat = (catsState as CatsLoaded).cats[i];
    return CatsTile(
      cat: cat,
      email: widget.email,
    );
  }
}
