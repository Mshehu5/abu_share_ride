import 'package:abu_share_ride/infoHandler/app_info.dart';
import 'package:abu_share_ride/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'ui/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:abu_share_ride/screens/main_screen.dart';
// import 'package:abu_share_ride/screens/login_screen. dart';
import 'package:abu_share_ride/themeProvider/theme_provider.dart';


Future<void> main() async {
  // Usually, you need to initialize the HERE SDK only once during the lifetime of an application.
  // _initializeHERESDK();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/config/.env");
  // await Firebase.initializeApp();
  runApp(const MainApp());
}

// void _initializeHERESDK() async {
//   // Needs to be called before accessing SDKOptions to load necessary libraries.
//   SdkContext.init(IsolateOrigin.main);

//   // Set your credentials for the HERE SDK.
//   String accessKeyId = "WLlnIIWLrSW2oJzjjrh28w";
//   String accessKeySecret =
//       "xMyvLFJSlp-sa7W7SPra78PzcxVILCDC-xD8tQ4jMiI3vhBrrnjLgxZSoZrIrzKSmLtLqNcgvat_PTTBPIFzrw";
//   SDKOptions sdkOptions =
//       SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

//   try {
//     await SDKNativeEngine.makeSharedInstance(sdkOptions);
//   } on InstantiationException {
//     throw Exception("Failed to initialize the HERE SDK.");
//   }
// }

class MainApp extends StatelessWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
    create: (context) =>AppInfo(),
    child: MaterialApp(
    title: "ABU SHARE RIDE",
    themeMode: ThemeMode.system,
    theme: MyThemes.lightTheme,
    darkTheme: MyThemes.darkTheme,
    debugShowCheckedModeBanner: false,
    home: MainScreen(),
    ),
    );
  }
}
