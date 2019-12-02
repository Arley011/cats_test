import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/cat.dart';

import '../../cats_repository.dart';
import '../events/cats_events.dart';
import '../states/cats_state.dart';

class CatsBloc extends Bloc<CatsEvent, CatsState> {
  final http.Client httpClient;
  //better to pass the CatsRepository instance in constructor!
  final _catsRepository = CatsRepository();

  CatsBloc({@required this.httpClient});

  @override
  CatsState get initialState => CatsUninitialized();

  bool isFavorite(String id) {
    final currentState = (state as CatsLoaded);
    final cat = currentState.favs.any((cat) => cat.id == id);
    return cat;
  }

  @override
  Stream<CatsState> mapEventToState(CatsEvent event) async* {
    final currentState = state;
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is CatsUninitialized) {
          final cats = await _fetchCats(20);
          final favs = await _getFavs(event.email);
          yield CatsLoaded(cats: cats, favs: favs, hasReachedMax: false);
        }
        if (currentState is CatsLoaded) {
          final cats = await _fetchCats(20);
          yield cats.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : currentState.favs.isEmpty
                  ? CatsLoaded(favs: await _getFavs(event.email), cats: currentState.cats + cats, hasReachedMax: false)
                  : currentState.copyWith(
                      cats: currentState.cats + cats,
                      hasReachedMax: false,
                    );
        }
      } catch (_) {
        print('Error in mapEvent');
        yield CatsError();
      }
    }
    if (event is UploadNew) {
      final cats = await _fetchCats(20);
      final favs = await _getFavs(event.email);
      yield CatsLoaded(cats: cats, favs: favs, hasReachedMax: false);
    }
    if (event is ClearCats) {
      yield CatsUninitialized();
    }

    if (event is ToggleFavorite) {
      try {
        if (currentState is CatsLoaded) {
          await _catsRepository.toggleFavoriteCat(event.cat, event.email);
          final favs = await _getFavs(event.email);
          yield favs.isEmpty ? CatsLoaded(favs: [], cats: currentState.cats, hasReachedMax: false) : CatsLoaded(favs: favs, hasReachedMax: false, cats: currentState.cats);
        }
      } catch (_) {
        print("error toggle");
      }
    }
  }

  Future<List<Cat>> _getFavs(String email) async {
    final docs = (await _catsRepository.myFavorites(email)).documents;
    List<Cat> favs = [];
    if (docs.isNotEmpty) {
      docs.forEach((document) {
        Cat cat = Cat(id: document.data['id'], imageUrl: document.data['imageUrl'], fact: document.data['fact']);
        favs.add(cat);
      });
    }
    return favs;
  }

  Future<List<Cat>> _fetchCats(int limit) async {
    List<Map<String, String>> listOfImages = await _fetchImageUrls(20);
    List<String> listOfFacts = await _fetchFacts(20);
    final cats = List.generate(
        limit,
        (index) => Cat(
              id: listOfImages[index]['id'],
              imageUrl: listOfImages[index]['url'],
              fact: listOfFacts[index],
            ));

    return cats;
  }

  Future<List<Map<String, String>>> _fetchImageUrls(int limit) async {
    final imageUrl = 'https://api.thecatapi.com/v1/images/search?mime_types=jpg,png&limit=$limit';
    final response = await httpClient.get(
      imageUrl,
      headers: {'x-api-key': '4d812264-79c1-4263-af97-1a9f16a9ecee'},
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body) as List;
      return List.generate(limit, (i) {
        return {'id': res[i]["id"], 'url': res[i]["url"]};
      });
    } else {
      print('Error in mapEvent');
      return null;
    }
  }

  Future<List<String>> _fetchFacts(int limit) async {
    final factUrl = 'https://catfact.ninja/facts?limit=$limit&max_length=400';
    final factResponse = await httpClient.get(factUrl);
    if (factResponse.statusCode == 200) {
      final res = json.decode(factResponse.body)['data'] as List;
      return List.generate(limit, (i) {
        return res[i]['fact'];
      });
    } else {
      print('Error in mapEvent');
      return null;
    }
  }

  bool _hasReachedMax(CatsState state) =>
      state is CatsLoaded && state.hasReachedMax;

  //this override are useless! need to be removed
  @override
  void onTransition(Transition<CatsEvent, CatsState> transition) {
    super.onTransition(transition);
  }

  //this override are useless! need to be removed
  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
  }
}
