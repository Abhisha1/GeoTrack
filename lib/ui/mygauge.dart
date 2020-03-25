import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/addentry.dart';
import 'package:flutter_app/utils/firebase_auth.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_app/ui/viewentry.dart';
import 'package:intl/intl.dart';


class MyGauge extends StatelessWidget {

  buildEventList(data, dates,documentIds){
    return new Expanded(
        child: ListView.builder(
        itemCount: dates.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return new ListTile(
              leading: Icon(Icons.receipt),
              title: Text(dates[index].toString()),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => ViewEntry(),
                    settings: RouteSettings(arguments: {
                      '_recordId': documentIds[index],
                      '_id': data["_id"],
                      '_indicator': data["indicator"],
                      '_metric': data["metric"]
                    })));
              });
  }));
  }

  buildCalendar(data, dates,documentIds,  _currentDate, _markedDateMap, context){
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.date_range),
                    text: "Calendar",),
                  Tab(icon: Icon(Icons.equalizer), text: "Charts"),
                ],
              ),
              title: Text('Tabs Demo'),

            ),
            body: TabBarView(
              children: [Column(
                children: <Widget>[ CalendarCarousel<Event>(
                  onDayPressed: (DateTime date, List<Event> events) {
                    _currentDate = date;
                    print("hello");
                  },
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                  ),
                  thisMonthDayBorderColor: Colors.grey,
                  weekFormat: false,
                  markedDatesMap: _markedDateMap,
                  height: 420.0,
                  selectedDateTime: _currentDate,
                  daysHaveCircularBorder: false,

                  /// null for not rendering any border, true for circular border, false for rectangular border
                ),
                dates.length>0 ? buildEventList(data, dates, documentIds): Text("No entries")
                ]
              ),
                Icon(Icons.directions_transit),
              ],

            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Map data = ModalRoute
                    .of(context)
                    .settings
                    .arguments;
                Navigator.push(context, MaterialPageRoute(builder: (
                    context) => AddEntryForm(),
                    settings: RouteSettings(arguments: {
                      '_id': data["_id"],
                      '_metric': data['_metric'],
                      '_indicator': data['_indicator']
                    })));
              },
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime _currentDate = DateTime.now();
    EventList<Event> _markedDateMap = new EventList<Event>(
      events: {},
    );
    List dates = [];
    List documentIds = [];
    Map data = ModalRoute.of(context).settings.arguments;
    return FutureBuilder(
        future: AuthProvider().retrieveGaugesRecords(data["_id"]),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.waiting &&
              projectSnap.hasData == false) {
            return  DefaultTabController(
              length: 2,
              child: Scaffold(
              appBar: AppBar(
              bottom: TabBar(
              tabs: [
              Tab(icon: Icon(Icons.date_range),
              text: "Calendar",),
              Tab(icon: Icon(Icons.equalizer), text: "Charts"),
              ],
              ),
              title: Text('Tabs Demo'),

              ),
              body: TabBarView(
              children: [Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: LinearProgressIndicator()
          ),
                Icon(Icons.directions_transit),
              ])));
          }
          else{
            if (projectSnap.hasData == false){
              return buildCalendar(data, dates, documentIds, _currentDate, _markedDateMap, context);
            }
            else{
              print(projectSnap.data);
              for (DocumentSnapshot x in projectSnap.data) {
                dates.add(x["date"].toDate());
                documentIds.add(x.documentID);
                _markedDateMap.add(
                    x["date"].toDate(),
                    new Event(
                        date: x["date"].toDate(),
                        title: x["date"].toString(),
                        icon: Icon(Icons.receipt)
                    )
                );
              }
              return buildCalendar(data, dates, documentIds, _currentDate, _markedDateMap, context);
            }
          }
        });
  }
}