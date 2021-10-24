import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _userFromFirebaseUser(UserCredential auth) {
    return (auth.user != null) ? User(uid: auth.user?.uid ?? "") : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(result);
    } catch (e) {
      // ignore: avoid_print
      print("signInWithEmailAndPassword errorr ---- $e");
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(result);
    } catch (e) {
      // ignore: avoid_print
      print("signUpWithEmailAndPassword errorr ---- $e");
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // ignore: avoid_print
      print("resetPass errorr ---- $e");

      return null;
    }
  }

  // Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
  //   final GoogleSignIn _googleSignIn = new GoogleSignIn();
  //   final GoogleSignInAccount googleSignInAccount =
  //       await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       idToken: googleSignInAuthentication.idToken,
  //       accessToken: googleSignInAuthentication.accessToken);
  //   AuthResult result = await _auth.signInWithCredential(credential);
  //   UserInfo userDetails = result.user;
  //   if (result == null) {
  //   } else {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
  //   }
  // }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class User {
  final String uid;
  User({required this.uid});
}
