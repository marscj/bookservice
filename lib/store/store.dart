import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_user.dart';

class Store {

  Store._();

  static Store _instance = new Store._();

  static Store get instance => _instance;

  Firestore firestore;

  void setting(FirebaseApp app) {
    firestore = new Firestore(app: app);
  }

  DocumentReference get userRef => firestore.collection('Users').document(UserWithFirebase.instance.firebaseUser?.uid);

  CollectionReference get bookingRef => firestore.collection('Bookings');

  CollectionReference get whiteList => firestore.collection('WhiteList');

  CollectionReference get usersRef => firestore.collection('Users');
}