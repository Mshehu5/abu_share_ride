import 'package:abu_share_ride/global/global.dart';
import 'package:abu_share_ride/models/user_models.dart';
import 'package:firebase_database/firebase_database.dart';

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
}
