// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:our_zone/util/modals/common_modals.dart';
import 'package:our_zone/util/static_data.dart';
import 'sharedpreference_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<OurZoneResponse> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return OurZoneResponse(code: 200, response: result.user?.uid);
    } catch (e) {
      print("Login Error ---- $e");
      return OurZoneResponse(code: 201, response: e.toString());
    }
  }

  Future<OurZoneResponse> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return OurZoneResponse(code: 200, response: result.user?.uid);
    } catch (e) {
      print("Register Error ---- $e");
      return OurZoneResponse(code: 201, response: e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("resetPass errorr ---- $e");

      return null;
    }
  }

  Future signOut() async {
    try {
      SPS.clear();
      UserData.primaryUser = null;
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
