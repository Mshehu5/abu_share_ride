import 'package:abu_share_ride/models/direction_details_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:abu_share_ride/models/user_models.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;

UserModel? userModelCurrentInfo;

DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDropOffAddress = "";

String GRapiKey = "30975ebc1cmsh0cc277b5e060d29p1fdf98jsn26de69446976";

final GRheaders = {
  'X-RapidAPI-Key': GRapiKey,
  'X-RapidAPI-Host':'google-maps-geocoding.p.rapidapi.com',
};
