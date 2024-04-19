import 'package:firebase_auth/firebase_auth.dart';
import 'package:abu_share_ride/models/user_models.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;

UserModel? userModelCurrentInfo;
