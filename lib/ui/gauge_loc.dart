import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

class GaugeLoc extends StatefulWidget {
  @override
  _GaugeLocState createState() => new _GaugeLocState();
}

class _GaugeLocState extends State<GaugeLoc> {
  LatLng _defLoc = new LatLng(-35.00, 137.00);
  @override
  void initState(){
    super.initState();
  }
  void _getUserLocation() async {
    print("get user location");
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng userLoc = new LatLng(position.latitude, position.longitude);
    setState(() {
      _defLoc = userLoc;
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Gauge Location')),
        body: new FlutterMap(
              options: new MapOptions(
                  center: _defLoc, minZoom: 5.0),
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
                      point: _defLoc,
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
              ]
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: _getUserLocation,
          tooltip: 'Get current location',
          child: Icon(Icons.pin_drop),
        )
    );
  }
}