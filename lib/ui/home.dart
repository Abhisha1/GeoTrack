import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/form.dart';
import 'package:flutter_app/utils/firebase_auth.dart';

class HomePage extends StatelessWidget {








  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AddGaugeForm(),
            AuthProvider().displayGauges(),
            RaisedButton(
              child: Text("Log out"),
              onPressed: (){
                AuthProvider().logOut();
              },
            )
          ],
        ),
      ),
    );
  }
}