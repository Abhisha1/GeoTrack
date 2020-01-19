import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;
  signInWithEmail(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(result.user == null){
        return false;
      }
      else{
        return true;
      }
    }
    catch (e){
      return false;
    }
  }

  Future<void> logOut() async{
    try{
      await _auth.signOut();
    }
    catch (e){
      print("error logging out");
    }
  }
  Future<bool> logInWithGoogle() async{
    try{
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account == null)
        return false;
      AuthResult res = await _auth.signInWithCredential
        (GoogleAuthProvider.getCredential(
          idToken: (await account.authentication).idToken,
          accessToken: (await account.authentication).accessToken));
      if (res.user == null)
        return false;
      return true;
    }
    catch (e){
      print("error logging with google");
      return false;
    }
  }

  Future<bool> submitGauge(String name, String indicator, String metric) async {
    try {
      var user = await _auth.currentUser();
      await db.collection("Gauges").add(
          {'user': user.email, 'name': name, 'indicator': indicator, 'metric': metric});
      return true;
    }
    catch (e) {
      print(e.toString());
      print("error submitting data");
      return false;
    }
  }


}

