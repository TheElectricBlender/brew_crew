import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';

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

  // get brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
        name: doc.data['name'] ?? '',
        strength: doc.data['strength'] ?? 0,
        sugars: doc.data['sugars'] ?? '0',
      );
    }).toList(); // because it returns an iterable
  }

  // document -> snapshot -> data

  // get userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
    );
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(
        _userDataFromSnapshot); // every time document changes, sends a snapshot
  }
}
