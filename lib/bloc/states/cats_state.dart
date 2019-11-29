import '../../models/cat.dart';

abstract class CatsState {}

class CatsUninitialized extends CatsState {}

class CatsError extends CatsState {}

class CatsLoaded extends CatsState {
  final List<Cat> favs;
  final List<Cat> cats;
  final bool hasReachedMax;

  CatsLoaded({
    this.cats,
    this.hasReachedMax,
    this.favs
  });

  CatsLoaded copyWith({
    List<Cat> cats,
    bool hasReachedMax,
    List<Cat> favs,
  }) {
    return CatsLoaded(
      cats: cats ?? this.cats,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      favs: favs ?? this.favs,
    );
  }

  Cat findById(String id) {
    return cats.firstWhere((cat) => cat.id == id);
  }

  Cat findByIdFavorite(String id){
    return favs.firstWhere((cat) => cat.id == id);
  }


}