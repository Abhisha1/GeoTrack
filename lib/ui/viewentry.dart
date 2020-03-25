import 'package:flutter/material.dart';
import 'package:flutter_app/utils/firebase_auth.dart';
import 'package:flutter_app/ui/mygauge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ViewEntry extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Map data = ModalRoute
        .of(context)
        .settings
        .arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder(
                      future: AuthProvider().retrieveRecord(data["_recordId"]),
                      builder: (context, projectSnap) {
                        if (projectSnap.connectionState ==
                            ConnectionState.waiting &&
                            projectSnap.hasData == false) {
                          return LinearProgressIndicator();
                        } else {
                          if (projectSnap.hasData == false)
                            return Text("No gauges");
                          else {
                            return new ListView.builder(
                                itemCount: projectSnap.data.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot key = projectSnap
                                      .data[index];
                                  return new ListTile(
                                      leading: Icon(Icons.receipt),
                                      title: Text(key["date"].toString()),
                                      subtitle: Text(key["notes"]),
                                      trailing: Icon(Icons.keyboard_arrow_left),
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) => MyGauge(),
                                                settings: RouteSettings(
                                                    arguments: {
                                                      '_id': key.documentID,
                                                      '_indicator': key["indicator"],
                                                      '_metric': key["metric"]
                                                    })));
                                      });
                                });
                          }
                        }
                      })
                ])));
  }
  }
