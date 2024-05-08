import 'package:abu_share_ride/global/global.dart';
import 'package:abu_share_ride/screens/profile_screen.dart';
import 'package:abu_share_ride/splashScreens/splash_screen.dart';
import 'package:abu_share_ride/ui/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      child: Drawer(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 50, 0, 20),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),

                  Text(
                    // userModelCurrentInfo!.name!,
                    "Student Rider",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (c) => ProfileScreen()));
                  },
                  child: Text(
                  "Edit Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.lightGreen,
                    ),
                  ),//
                  ),//
                  SizedBox(height: 30,),

                            Text("Your Rides", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                            SizedBox(height: 15,),

                            Text("Payment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                            SizedBox(height: 15,),

                            Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                            SizedBox(height: 15,),

                            Text("promos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                            SizedBox(height: 15,),

                            Text("Help", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                            SizedBox(height: 15,),

                            Text("Free Rides", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                            SizedBox(height: 300,),
                ],
              ),
              GestureDetector(
                onTap: (){
                  firebaseAuth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
                },
                child: Text(
                  "logout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color : Colors.red,
                  ),
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }

}
