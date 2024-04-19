import 'package:flutter/material.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MapboxMap? mapboxMap;
  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        //   body: MapWidget(
        // key: ValueKey("mapWidget"),
        // onMapCreated: _onMapCreated,)
        );
  }
}
