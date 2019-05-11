import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

export 'upload.dart';

class Storage {

  static Storage _instance = new Storage();

  static Storage get instance => _instance;

  FirebaseStorage firebaseStorage;

  void setting(FirebaseApp app, {storageBucket}){
    firebaseStorage = new FirebaseStorage(app: app, storageBucket: storageBucket);
  }

  StorageReference get ref => firebaseStorage.ref();

  StorageReference get bookingRef => ref.child('Bookings');

  StorageReference get userRef => ref.child('Users');
}