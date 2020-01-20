import 'package:flutter/material.dart';
import 'package:flutter_app/ui/addentry.dart';

class MyGauge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.date_range), text: "Calendar",),
                Tab(icon: Icon(Icons.equalizer), text: "Charts"),
              ],
            ),
            title: Text('Tabs Demo'),

          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
            ],

          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_circle),
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => AddEntryForm()));
            },
          )),
      ),
    );
  }
}