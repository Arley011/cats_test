import 'package:cloud_firestore/cloud_firestore.dart';

import './firestore_provider.dart';
import './models/cat.dart';

class CatsRepository {
  final _firestoreProvider = FirestoreProvider();

  Future<void> toggleFavoriteCat(Cat cat, String email) =>
      _firestoreProvider.toggleFavoriteCat(cat, email);

  Future<QuerySnapshot> myFavorites(String email) =>
      _firestoreProvider.myFavorites(email);

  Future<void> registerUserToFirestore(
          {String email, String name, String photoUrl}) =>
      _firestoreProvider.registerUser(
          email: email, name: name, photoUrl: photoUrl);
}
