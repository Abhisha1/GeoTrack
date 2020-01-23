import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/mygauge.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;

  signInWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user == null) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("error logging out");
    }
  }

  Future<bool> logInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account == null) return false;
      AuthResult res = await _auth.signInWithCredential(
          GoogleAuthProvider.getCredential(
              idToken: (await account.authentication).idToken,
              accessToken: (await account.authentication).accessToken));
      if (res.user == null) return false;
      return true;
    } catch (e) {
      print("error logging with google");
      return false;
    }
  }

  Future<bool> submitGauge(
      String name, String indicator, String metric, GeoPoint loc) async {
    try {
      var user = await _auth.currentUser();
      await db.collection("Gauges").add({
        'user': user.email,
        'name': name,
        'indicator': indicator,
        'metric': metric,
        "location": loc
      });
      return true;
    } catch (e) {
      print(e.toString());
      print("error submitting data");
      return false;
    }
  }

  Future<List<DocumentSnapshot>> retrieveUsersGauges() async {
    var user = await _auth.currentUser();
    var data = await db
        .collection("Gauges")
        .where("user", isEqualTo: user.email)
        .getDocuments()
        .then((snapshot) {
      print(snapshot.documents.first.documentID);
      return snapshot.documents;
    });
    return data;
  }

  Widget displayGauges() {
    return FutureBuilder(
        future: retrieveUsersGauges(),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.waiting &&
              projectSnap.hasData == false) {
            return LinearProgressIndicator();
          } else {
            if (projectSnap.hasData == false)
              return Text("No gauges");
            else {
              print(projectSnap.data.toString());
              return new ListView.builder(
                  itemCount: projectSnap.data.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot key = projectSnap.data[index];
                    return new ListTile(
                        leading: key["indicator"] == "Rainfall" ? Icon(Icons.beach_access) : Icon(Icons.wb_sunny),
                        title: Text(key["name"]),
                        subtitle: Text(key["indicator"]),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          print("show data");
                          Navigator.push(context,MaterialPageRoute(builder: (context) => MyGauge(),
                          settings: RouteSettings(arguments: {
                          '_id': key.documentID,
                            '_indicator': key["indicator"],
                            '_metric': key["metric"]
                          })));
                        });
                  });
            }
          }
        });
  }

  Future<bool> submitEntry(
      String id, double amount, DateTime date, double duration, String notes) async {
    try {
      var user = await _auth.currentUser();
      await db.collection("Entries").add({
        'gauge_id': id,
        'amount': amount,
        'date': date,
        'duration': duration,
        'notes': notes
      });
      return true;
    } catch (e) {
      print(e.toString());
      print("error submitting data");
      return false;
    }
  }

  Future<List<DocumentSnapshot>> retrieveGaugesRecords(String gaugeId) async {
    print(gaugeId);
    var data = await db
        .collection("Entries")
        .where("gauge_id", isEqualTo: gaugeId)
        .getDocuments()
        .then((snapshot) {
          if(snapshot.documents.isNotEmpty){
            print(snapshot.documents.first.documentID);
          }
      return snapshot.documents;
    });
    return data;
  }


}
