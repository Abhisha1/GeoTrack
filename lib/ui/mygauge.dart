import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/addentry.dart';
import 'package:flutter_app/utils/firebase_auth.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class MyGauge extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    DateTime _currentDate = DateTime.now();
    EventList<Event> _markedDateMap = new EventList<Event>(
      events: {},
    );
    return Scaffold(
      body: DefaultTabController(
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
            children: [Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: CalendarCarousel<Event>(
            onDayPressed: (DateTime date, List<Event> events) {
               _currentDate = date;
               print("hello");
            },
            weekendTextStyle: TextStyle(
              color: Colors.red,
            ),
            thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
            customDayBuilder: (   /// you can provide your own build function to make custom day containers
                bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime day,
                ) {
              /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
              /// This way you can build custom containers for specific days only, leaving rest as default.

              // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
              Map data = ModalRoute.of(context).settings.arguments;
              print(data.toString());
              AuthProvider().retrieveGaugesRecords(data["_id"]).then((value){
                value.forEach((f){

                });
              });
              return FutureBuilder(
                  future: AuthProvider().retrieveGaugesRecords(data["_id"]),
                  builder: (context, projectSnap) {
                      if(projectSnap.connectionState == ConnectionState.done){
                        if(projectSnap.hasData == true){
                          return Icon(Icons.add);
                          }
                        else{
                          return new Container();
                        }
                      }
                      else{
                        return new Container();
                      }
    } );



//              if (day.day == 15) {
//                return Center(
//                  child: Icon(Icons.local_airport),
//                );
//              } else {
//                return null;
//              }
            },
            weekFormat: false,
            markedDatesMap: _markedDateMap,
            height: 420.0,
            selectedDateTime: _currentDate,
            daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
          ),
        ),
              Icon(Icons.directions_transit),
            ],

          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Map data = ModalRoute.of(context).settings.arguments;
              Navigator.push(context,MaterialPageRoute(builder: (context) => AddEntryForm(),
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
}