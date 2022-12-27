import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/AltProfile/alt_Profile.dart';
import 'package:i_exist_1/Screens/AltProfile/alt_profileHelpers.dart';
import 'package:i_exist_1/Screens/ChatRoom/ChatRoomHelper.dart';
import 'package:i_exist_1/Screens/Feed/FeedHelpers.dart';
import 'package:i_exist_1/Screens/Home/HomeScreenHelpers.dart';
import 'package:i_exist_1/Screens/Landing_Page/landingHelpers.dart';
import 'package:i_exist_1/Screens/Landing_Page/landingServices.dart';
import 'package:i_exist_1/Screens/Landing_Page/landingUtils.dart';
import 'package:i_exist_1/Screens/Messaging/groupMessaging/groupMessegingHelper.dart';
import 'package:i_exist_1/Screens/Profile/profileHelpers.dart';
import 'package:i_exist_1/Screens/SplashScreen/ScreenSplash.dart';
import 'package:i_exist_1/Screens/Stories/stories_helper.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:i_exist_1/Utils/PostOptions.dart';
import 'package:i_exist_1/Utils/Uploadpost.dart';
import 'package:provider/provider.dart';

import 'Screens/Messaging/directMessaging/directMessagingHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
    DeviceOrientation.portraitDown, 
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StoriesHelper()),
          ChangeNotifierProvider(create: (_) => DirectMessagingHelper()),
          ChangeNotifierProvider(create: (_) => GroupMessegingHelper()),
          ChangeNotifierProvider(create: (_) => ChatRoomHelper()),
          ChangeNotifierProvider(create: (_) => AltProfileHelper()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingService()),
          ChangeNotifierProvider(create: (_) => FirebaseOpretions()),
          ChangeNotifierProvider(create: (_) => LandingUtils()),
          ChangeNotifierProvider(create: (_) => HomeScreenHelpers()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => UploadPost()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
          ChangeNotifierProvider(create: (_) => PostFunctions())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
              fontFamily: "Poppins",
              canvasColor: Colors.transparent,
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: constantColors.blueColor)
              // primarySwatch: Colors.blue,
              ),
          home: const ScreenSplash(),
        ));
  }
}
