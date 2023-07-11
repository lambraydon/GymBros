import "package:firebase_auth/firebase_auth.dart";
import "package:gymbros/models/gbuser.dart";
import "package:gymbros/services/databaseservice.dart";

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  //authentication changes user Stream
  Stream<GbUser?> get user {
    return _auth.authStateChanges()
        .map(_gbUserFromFirebaseUser);
  }

  //create gbUser from Firebase User
  GbUser? _gbUserFromFirebaseUser(User? user) {
    return user != null ? GbUser(userID: user.uid) : null;
}
  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential res = await _auth.signInAnonymously();
      User user = res.user!;
      return GbUser(userID: user.uid);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      await DatabaseService(uid: user.uid).createUserProfile(username, email);
      return GbUser(userID: user.uid);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      //create new userProfile on registration
      return GbUser(userID: user.uid);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  // sign out
  Future signOut() async {
    try{
      return _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  String getUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  String getEmail() {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  // register with Facebook

  // sign in with Facebook
}
