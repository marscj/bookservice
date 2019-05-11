import 'package:firebase_auth/firebase_auth.dart';

class UserWithFirebase {

  UserWithFirebase._() {
    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      firebaseUser = user;
    });
  }

  static UserWithFirebase _instance = new UserWithFirebase._();

  static UserWithFirebase get instance => _instance;

  FirebaseUser firebaseUser;

  Future<void> setting() async {
    return FirebaseAuth.instance.currentUser().then((user) {
      firebaseUser = user;
      // return firebaseUser?.reload()?.catchError((onError){
      //   firebaseUser = null;
      //   print(onError.toString());
      // });
    });
  }

  void reload(FirebaseUser user) {
    firebaseUser = user;
  }
}