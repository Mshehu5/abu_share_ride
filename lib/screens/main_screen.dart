import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:latlng/latlng.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  // loc.location location = loc.location();

  double searchLocationContainerHeight = 220;
  double waitingResponsefromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circleset = {};

  // String userName = "";
  // String userEmail = "";

  bool openNavigationDrawer = true;
  bool activeNearbyDriverkeysLoaded = false;

  locateUserPosition() async {
    Position cPostion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPostion;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);
  }

  // locatateUserPosition() async {
  //   Position cPostion = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.medium);
  //   userCurrentPosition = cPostion;

  // }

  // BitmapDescriptor? activeNearbyIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: _kGooglePlex,
              polylines: polylineSet,
              markers: markerSet,
              circles: circleset,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {});

                locateUserPosition();
              },
              onCameraMove: (CameraPosition? position) {
                if (pickLocation != position!.target) {
                  setState(() {
                    pickLocation = position.target;
                  });
                }
              },
              onCameraIdle: () {
                //get adress from latlng
              },
            ),
          ],
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         //   body: MapWidget(
//         // key: ValueKey("mapWidget"),
//         // onMapCreated: _onMapCreated,)
//         );
//   }
// }
