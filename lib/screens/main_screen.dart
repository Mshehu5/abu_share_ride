import 'dart:async';
import 'package:abu_share_ride/screens/drawer_screen.dart';
import 'package:abu_share_ride/screens/precise_pickup_location.dart';
import 'package:abu_share_ride/screens/search_places_screen.dart';
import 'package:abu_share_ride/themeProvider/theme_provider.dart';

import 'package:abu_share_ride/global/global.dart';
import 'package:abu_share_ride/global/map_key.dart';
import 'package:abu_share_ride/helpers/assistant_methods.dart';
import 'package:abu_share_ride/infoHandler/app_info.dart';
import 'package:abu_share_ride/models/directions.dart';
import 'package:abu_share_ride/widgets/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:provider/provider.dart';

import '../helpers/geofire_assistant.dart';
import '../models/active_nearby_available_drivers.dart';

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
  BitmapDescriptor? activeNearbyIcon;
  double suggestedRidesContainerHeights = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circlesSet = {};

  String userName = "";
  String userEmail = "";

  bool openNavigationDrawer = true;
  bool activeNearbyDriverkeysLoaded = false;

  String selectedVechileType = "" ;

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
    LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
    CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
    await AssistantMethods.searchAddressForGoegraphicCordinates(
        userCurrentPosition!, context);
    print("This is our address = " + humanReadableAddress);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();

    // initializeGeoFireListener();
    // AssistantMethods.readTripsKeysForOnlineUser(context);
  }

  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");
    Geofire.queryAtLocation(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);

      if (map != null) {
        var callBack = map["callBack"];

        switch (callBack) {
        //whenever any driver becomes active/online
          case Geofire.onKeyEntered:
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers = ActiveNearByAvailableDrivers();
            activeNearByAvailableDrivers.locationLatitude = map["latitude"];
            activeNearByAvailableDrivers.locationLongtitude = map["longtitude"];
            activeNearByAvailableDrivers.driverId = map["key"];
            GeoFireAssistant.activeNearByAvailableDriversList.add(
                activeNearByAvailableDrivers);
            if (ActiveNearByAvailableDrivers == true) {
              displayActiverDriversOnUserMap();
            }
            break;
        //whenever any driver becomes non-active/online
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map["key"]);
            displayActiverDriversOnUserMap();
            break;
        //whenever driver moves = update driver location
          case Geofire.onKeyMoved:
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers = ActiveNearByAvailableDrivers();
            activeNearByAvailableDrivers.locationLatitude = map["latitude"];
            activeNearByAvailableDrivers.locationLongtitude = map["longtitude"];
            activeNearByAvailableDrivers.driverId = map["key"];
            GeoFireAssistant.updateActiveNearByAvailableDriverLocation(
                activeNearByAvailableDrivers);
            displayActiverDriversOnUserMap();
            break;

        //display those online active drivers on user's map
          case Geofire.onGeoQueryReady:
            activeNearbyDriverkeysLoaded = true;
            displayActiverDriversOnUserMap();
            break;
        }
      }
      setState(() {

      });
    });
  }

  displayActiverDriversOnUserMap() {
    setState(() {
      markerSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for (ActiveNearByAvailableDrivers eachDriver in GeoFireAssistant
          .activeNearByAvailableDriversList) {
        LatLng eachDriverActivePosition = LatLng(
            eachDriver.locationLatitude!, eachDriver.locationLongtitude!);

        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        ); // Marker

        driversMarkerSet.add(marker);
      }

      setState(() {
        markerSet = driversMarkerSet;
      });
    });
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageconfiguration = createLocalImageConfiguration(
          context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageconfiguration, "images/car.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  Future<void> drawPolyLineFromOriginToDestination(bool darkTheme) async {
    var originPosition =
        Provider
            .of<AppInfo>(context, listen: false)
            .userPickUpLocation;
    var destinationPosition =
        Provider
            .of<AppInfo>(context, listen: false)
            .userDropOffLocation;
    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          ProgressDialog(
            message: "Please wait...",
          ),
    );
    var directionDetailsInfo =
    await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResultList =
    pPoints.decodePolyline(directionDetailsInfo.e_points!);

    pLineCoordinatedList.clear();
    if (decodePolyLinePointsResultList.isNotEmpty) {
      decodePolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.lightGreen,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinatedList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );
      polylineSet.add(polyline);
    });
    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }
    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: MarkerId("originID"),
      infoWindow:
      InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {
      markerSet.add(originMarker);
      markerSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    ); // Circle
    Circle destinationCircle = Circle(
      circleId: CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    ); // Circle
    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

  // getAddressFromLatLng() async {
  //   try {
  //     GeoData data = await Geocoder2.getDataFromCoordinates(
  //         latitude: pickLocation!.latitude,
  //         longitude: pickLocation!.longitude,
  //         googleMapApiKey: mapKey);
  //     setState(() {
  //       Directions userPickUpAddress = Directions();
  //       userPickUpAddress.locationLatitude = pickLocation!.latitude;
  //       userPickUpAddress.locationLongitude = pickLocation!.longitude;
  //       userPickUpAddress.locationName = data.address;
  //       // _address = data.address;

  //       Provider.of<AppInfo>(context, listen: false)
  //           .updatePickUpLocationAddress(userPickUpAddress);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }


  void showSuggestedRidescontainer() {
    setState(() {
      suggestedRidesContainerHeights = 400;
      bottomPaddingOfMap = 400;
    });
  }


    checkIfLocationPermissionAllowed() async {
      _locationPermission = await Geolocator.requestPermission();
      if (_locationPermission == LocationPermission.denied) {
        _locationPermission = await Geolocator.requestPermission();
      }
    }

    @override
    void initState() {
// TODO: implement initState
      super.initState();
      checkIfLocationPermissionAllowed();
    }

    @override
    Widget build(BuildContext context) {
      createActiveNearByDriverIconMarker();
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          key: _scaffoldState,
          drawer: DrawerScreen(),
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                initialCameraPosition: _kGooglePlex,
                polylines: polylineSet,
                markers: markerSet,
                circles: circlesSet,
                onMapCreated: (GoogleMapController controller) {
                  _controllerGoogleMap.complete(controller);
                  newGoogleMapController = controller;

                  setState(() {
                    bottomPaddingOfMap = 200;
                  });

                  locateUserPosition();
                },

                // cooment this later

                ////////

                // onCameraMove: (CameraPosition? position) {
                //   if (pickLocation != position!.target) {
                //     setState(() {
                //       pickLocation = position.target;
                //     });
                //   }
                // },
                // onCameraIdle: () {
                //   getAddressFromLatLng();
                // },
              ),

// Comment this out
//// /////////////////////////////////////////////////////////
///////////////////////////

              // Align(
              //   alignment: Alignment.center,
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 35.0),
              //     child: Image.asset(
              //       "assets/image/pick.png",
              //       height: 45,
              //       width: 45,
              //     ),
              //   ),
              // ),

              // custom hamburger button for drawer
              Positioned(
                  top: 50,
                  right: 20,
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        _scaffoldState.currentState!.openDrawer();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.menu,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ),
                  )),

              //ui for searching location
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(10)), // BoxDecoration
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.lightGreen,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "From",
                                            style: TextStyle(
                                              color: Colors.lightGreen,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            Provider
                                                .of<AppInfo>(context)
                                                .userPickUpLocation !=
                                                null
                                                ? (Provider
                                                .of<AppInfo>(context)
                                                .userPickUpLocation!
                                                .locationName!)
                                                .substring(0, 24) +
                                                "..."
                                                : "Not Getting Address",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: Colors.lightGreen,
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: GestureDetector(
                                    onTap: () async {
                                      // go to search Places
                                      var responseFromSearchScreen =
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) =>
                                                  SearchPlaceScreen()));

                                      if (responseFromSearchScreen ==
                                          "obtainedDropOff") {
                                        setState(() {
                                          openNavigationDrawer = false;
                                        });
                                      }

                                      await drawPolyLineFromOriginToDestination;
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.lightGreen,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "To",
                                              style: TextStyle(
                                                color: Colors.lightGreen,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              Provider
                                                  .of<AppInfo>(context)
                                                  .userDropOffLocation !=
                                                  null
                                                  ? Provider
                                                  .of<AppInfo>(context)
                                                  .userDropOffLocation!
                                                  .locationName!
                                                  : "Where to",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) =>
                                                PrecisePickupScreen()));
                                  },
                                  child: Text(
                                    " Change Pick Up",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightGreen,
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (Provider
                                        .of<
                                        AppInfo>(context, listen: false)
                                        .userDropOffLocation != null) {
                                      showSuggestedRidescontainer();
                                    }
                                  },
                                  child: Text(
                                    " Show Fare",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightGreen,
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),


              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: suggestedRidesContainerHeights,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),

                      )
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                )
                            ),


                            SizedBox(width: 15,),

                            Text(
                                Provider
                                    .of<AppInfo>(context)
                                    .userPickUpLocation !=
                                    null
                                    ? (Provider
                                    .of<AppInfo>(context)
                                    .userPickUpLocation!
                                    .locationName!)
                                    .substring(0, 24) +
                                    "..."
                                    : "Not Getting Address",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Icon(
                        Icons.star,
                        color: Colors.white,
                      )
                  ),


                  SizedBox(width: 15,),

                  Text(
                      Provider
                          .of<AppInfo>(context)
                          .userDropOffLocation !=
                          null
                          ? Provider
                          .of<AppInfo>(context)
                          .userDropOffLocation!
                          .locationName!
                          : "Where to",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )
                  ),
                ],
              ),

              SizedBox(height: 20,),
              
              
              // Text("SUGGESTED RIDES",
              // style: TextStyle(
              //   fontWeight: FontWeight.bold,
              // ),
              // ),

              SizedBox(height: 20,),

          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {

                    });
      },
                  child: Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Column(
                              children: [
                              // Image.asset("assets/image/sport-car.png", scale: 4,),
                            SizedBox (height: 4,),
                            Text(
                              "Car",
                              style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              ),
                            ),

                              SizedBox(height: 2),
                  
                                Text(tripDirectionDetailsInfo != null ? "${((AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 2) * 107).toStringAsFixed(1)}" : "null",
                  style: TextStyle(
                    color: Colors.grey
                  ),
                                )
                  
                                // Positioned(
                                //   top: 40,
                                //   right: 20,
                                //   left: 20,
                                //   child: Container(
                                //     decoration: BoxDecoration (
                                //       border: Border.all(color: Colors.black),
                                //       color: Colors.white,
                                //     ), // BoxDecoration
                                //     padding: EdgeInsets.all(20),
                                //     child: Text(Provider.of<AppInfo>(context).userPickUpLocation != null ?
                                //     (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 24) + "..."
                                //         : "Not Getting Address",
                                //     overflow: TextOverflow.visible, softWrap: true,
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                ),
        ],
      )
      ]
      ),
      ),
      );
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
}
