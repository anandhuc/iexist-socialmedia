import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String? userUid;
  String? get getUserUid => userUid;

  Future logIntoAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    userUid = user?.uid;
    print(userUid);
    notifyListeners();
  }

  Future createAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    userUid = user?.uid;
    print("created user uid==> $userUid");
    notifyListeners();
  }

  Future logOutViaEmail(){
    return firebaseAuth.signOut();
  }

  Future signInwithGoogle() async {
    print("signin in with goooooooooooooogle");
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);

    final User? user = userCredential.user;
    assert(user?.uid != null);

    userUid = user!.uid;
    print("Google User uid ==>");
    print("Google User uid ==>$userUid");
    notifyListeners();
  }

  Future signOutWithGoogle()async{
    return googleSignIn.signOut();
  }
}
