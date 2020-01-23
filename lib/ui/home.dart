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
            AuthProvider().displayGauges()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        heroTag: null,
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context) => AddGaugeForm()));
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Log off'),
              onTap: (){
                AuthProvider().logOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}