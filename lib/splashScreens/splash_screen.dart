import 'dart:async';

import 'package:abu_share_ride/helpers/assistant_methods.dart';
import 'package:abu_share_ride/global/global.dart';
import 'package:abu_share_ride/screens/login_screen.dart';
import 'package:abu_share_ride/screens/main_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(Duration(seconds: 3), () async {
      if (await firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null
            ? AssistantMethods.readCurrentOnlineUserinfo()
            : null;
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("ABU SHARE RIDE"),
      ),
    );
  }
}
