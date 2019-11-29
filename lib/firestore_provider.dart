import 'package:cloud_firestore/cloud_firestore.dart';

import './models/cat.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;



  Future<void> registerUser({String email, String name, String photoUrl}) async {
    return _firestore
        .collection("users")
        .document(email)
        .setData({'email': email, 'name': name, 'photoUrl': photoUrl});
  }

  Future<void> toggleFavoriteCat(
    Cat cat,
    String documentId,
  ) async {
    QuerySnapshot result = await _firestore
        .collection("users")
        .document(documentId)
        .collection("favorites")
        .where('id', isEqualTo: cat.id)
        .getDocuments();
    print(result);
    final List<DocumentSnapshot> docs = result.documents;

    if (docs.length == 0) {

      return _firestore
          .collection("users")
          .document(documentId)
          .collection("favorites")
          .document(cat.id)
          .setData({
        'id': cat.id,
        'imageUrl': cat.imageUrl,
        'fact': cat.fact,
      });
    }else{
      return _firestore.collection("users").document(documentId).collection("favorites").document(cat.id).delete();
    }
  }

  Future<QuerySnapshot> myFavorites(String documentId) async{
    return await _firestore.collection("users").document(documentId).collection("favorites").getDocuments();
  }


}
