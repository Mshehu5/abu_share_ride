import 'package:abu_share_ride/global/global.dart';
import 'package:abu_share_ride/global/map_key.dart';
import 'package:abu_share_ride/helpers/request_assistant.dart';
import 'package:abu_share_ride/models/directions.dart';
import 'package:abu_share_ride/models/user_models.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../infoHandler/app_info.dart';

class AssistantMethods {
  static void readCurrentOnlineUserinfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }


  static Future<String> searchAddressForGoegraphicCordinates(Position position,context) async {
  String apiUrl ="https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude}, ${position.longitude}&key=$mapKey";
  String humanReadableAddress = "";

  var requestResponse = await RequestAssistant.receiveRequest(apiUrl);
  print(requestResponse);

  if(requestResponse != "Error Occured. Failed No Response"){
    humanReadableAddress = requestResponse["results"][0]["formatted_address"];


    Directions userPickUpAddress = Directions();
    userPickUpAddress.locationLatitude = position. latitude;
    userPickUpAddress.locationLongitude = position.longitude;
    userPickUpAddress.locationName = humanReadableAddress;

    Provider.of<AppInfo> (context, listen: false).updatePickUpLocationAddress(userPickUpAddress);

  }

  return humanReadableAddress;
  }
}
