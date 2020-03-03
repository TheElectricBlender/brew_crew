import 'package:cloud_firestore/cloud_firestore.dart';

// method and properties to be used to interact with database
class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  // if dont exist, firestore will automatically create one
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  // used when first signed up and when they update their data
  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }



}
