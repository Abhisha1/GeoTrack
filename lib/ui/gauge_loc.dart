import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/home.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_app/utils/firebase_auth.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

class GaugeLoc extends StatefulWidget {
  @override
  _GaugeLocState createState() => new _GaugeLocState();
}

class _GaugeLocState extends State<GaugeLoc> {
//  final LatLng _defLoc = new LatLng(-35.00, 137.00);
  LatLng _markerPos = new LatLng(-35.00, 137.00);
  final MapController controller = new MapController();
  @override
  void initState(){
    super.initState();
  }
  void _getUserLocation() async {
    print("get user location");
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng userLoc = new LatLng(position.latitude, position.longitude);
    if(controller.ready) {
      controller.move(userLoc, controller.zoom);
    }
    setState(() {
      _markerPos = userLoc;
    });
  }

  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(title: Text("Gauge location")),
        body: new FlutterMap(
              options: new MapOptions(
                  center: _markerPos, minZoom: 5.0),
              layers: [
                new TileLayerOptions(
                    urlTemplate:
                    "https://api.mapbox.com/styles/v1/abskebabs/ck5a77sv91g1w1co91da2ydbm/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWJza2ViYWJzIiwiYSI6ImNrNTd0bjRlMjA3a2ozbnBzc2x4YWEzNDcifQ.9AUFUIzHLIvBqcmxIGrmrQ",
                    additionalOptions: {
                      'accessToken':
                      'pk.eyJ1IjoiYWJza2ViYWJzIiwiYSI6ImNrNTd0bjRlMjA3a2ozbnBzc2x4YWEzNDcifQ.9AUFUIzHLIvBqcmxIGrmrQ',
                      "id": 'mapbox.mapbox-streets-v7'
                    }
                ),
                new MarkerLayerOptions(markers: [
                  new Marker(
                      width: 45.0,
                      height: 45.0,
                      point: _markerPos,
                      builder: (context) => new Container(
                        child: IconButton(
                          icon: Icon(Icons.location_on),
                          color: Colors.blue,
                          iconSize: 45.0,
                          onPressed: () {
                            print('Marker tapped');
                          },
                        ),
                      ))
                  ])
              ],
            mapController: controller,
          ),
        persistentFooterButtons: <Widget>[
          FloatingActionButton(
          onPressed: _getUserLocation,
          tooltip: 'Get current location',
          child: Icon(Icons.pin_drop),
          heroTag: null
        ),
    FloatingActionButton(
    tooltip: 'Submit',
    child: Icon(Icons.done),
      heroTag: null,
      onPressed: ()async{
        GeoPoint gaugeLocation = GeoPoint(_markerPos.latitude, _markerPos.longitude);
        Map data = ModalRoute.of(context).settings.arguments;
        bool res = await AuthProvider().submitGauge(data["_name"], data["_selectedIndicator"], data["_selectedMetric"], gaugeLocation);
        if (!res){
        print("Firestore submission failed");
        }
        if (res)
          print("success");
        Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage()));
    }
    )
        ]
    );
  }
}