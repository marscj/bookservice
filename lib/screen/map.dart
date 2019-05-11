import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import '../models.dart';

class MyMap extends StatefulWidget{

  MyMap(this.place);

  final PlaceModel place;

  @override
  State<MyMap> createState() => new MyMapState();
}

class MyMapState extends State<MyMap> {

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    body: new Stack(
      children: <Widget>[
        new FlutterMap(
          options: new MapOptions(
            center: new LatLng(widget.place.latitude, widget.place.longitude),
            zoom: 13.0,
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate: "https://api.tiles.mapbox.com/v4/"
                  "{id}/{z}/{x}/{y}@2x.png?access_token=sk.eyJ1IjoibWFycy1jaiIsImEiOiJjam83YXo2bWIwMHI2M3BvN3VoM2NoeW8xIn0.o90vmRpd9BNod0Blbd3qsw",
              additionalOptions: {
                'accessToken': 'sk.eyJ1IjoibWFycy1jaiIsImEiOiJjam83YXo2bWIwMHI2M3BvN3VoM2NoeW8xIn0.o90vmRpd9BNod0Blbd3qsw',
                'id': 'mapbox.streets',
              },
            ),
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: new LatLng(widget.place.latitude, widget.place.longitude),
                  builder: (ctx) =>
                  new Container(
                    child: new Icon(Icons.add_location)
                  ),
                ),
              ]
            ),
          ],
        ),
        new Padding(
          padding: new EdgeInsets.only(top: 25.0),
          child: new BackButton(),
        )
      ],
    )
  );
}