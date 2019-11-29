import 'package:equatable/equatable.dart';

class Cat extends Equatable{
  final String id;
  final String fact;
  final String imageUrl;

  Cat({
    this.id,
    this.fact,
    this.imageUrl,
  });

  Cat copyWith({String id, String fact, String imageUrl, bool isFavorite}){
    return Cat(
      id: id ?? this.id,
      fact:  fact ?? this.fact,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }


  @override
  // TODO: implement props
  List<Object> get props => [id, fact, imageUrl, ];
}
