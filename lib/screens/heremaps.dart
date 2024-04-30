// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:latlng/latlng.dart';
// import 'package:location/location.dart' as loc;

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

//   LatLng? pickLocation;
//   // loc.Location Location = loc.Location();
//   String? _address;

//   // loc.location location = loc.location();

//   double searchLocationContainerHeight = 220;
//   double waitingResponsefromDriverContainerHeight = 0;
//   double assignedDriverInfoContainerHeight = 0;

//   Position? userCurrentPosition;
//   var geoLocation = Geolocator();

//   LocationPermission? _locationPermission;
//   double bottomPaddingOfMap = 0;
//   // List<LatLng> pLineCoordinatedList = [];
//   // Set<Polyline> polylineSet = {};
//   // Set<Marker> markerSet = {};
//   // set<Circle> circleset = {};
//   // String userName = "";
//   // String userEmail = "";
//   bool openNavigationDrawer = true;
//   bool activeNearbyDriverkeysLoaded = false;

//   /// Determine the current position of the device.
//   ///
//   /// When the location services are not enabled or permissions
//   /// are denied the `Future` will return an error.
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     Position cPostion = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     return userCurrentPosition = cPostion;
//   }
//   // locatateUserPosition() async {
//   //   Position cPostion = await Geolocator.getCurrentPosition(
//   //       desiredAccuracy: LocationAccuracy.medium);
//   //   userCurrentPosition = cPostion;

//   // LatLng latLngPosition = LatLng.degree(userCurrentPosition!.latitude, userCurrentPosition!.longitude)
//   // }

//   // BitmapDescriptor? activeNearbyIcon;
//   void _onMapCreated(HereMapController hereMapController) {
//     _determinePosition();
//     hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
//         // locatateUserPosition();
//         (MapError? error) {
//       if (error != null) {
//         print('Map scene not loaded. MapError: ${error.toString()}');
//         return;
//       }
//       print("yoooy----------------------------------");
//       print(userCurrentPosition!.latitude);
//       print(userCurrentPosition!.longitude);
//       print("----------------------------------");

//       const double distanceToEarthInMeters = 8000;
//       MapMeasure mapMeasureZoom =
//           MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
//       hereMapController.camera.lookAtPointWithMeasure(
//           GeoCoordinates(
//               userCurrentPosition!.latitude, userCurrentPosition!.longitude),
//           mapMeasureZoom);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         body: HereMap(onMapCreated: _onMapCreated),
//       ),
//     );
//   }
// }

// //   @override
// //   Widget build(BuildContext context) {
// //     return new Scaffold(
// //         //   body: MapWidget(
// //         // key: ValueKey("mapWidget"),
// //         // onMapCreated: _onMapCreated,)
// //         );
// //   }
// // }
