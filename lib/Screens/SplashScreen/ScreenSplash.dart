import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/Landing_Page/landingPage.dart';
import 'package:page_transition/page_transition.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  ConstantColors constantColors=ConstantColors();
  @override
  void initState() {
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: ScreenLandingPage(),
                type: PageTransitionType.leftToRight)));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
            text: TextSpan(
                text: "i",
                style: TextStyle(
                  fontFamily: 'Solway',
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                children: <TextSpan>[
              TextSpan(
                text: 'Exist',
                style: TextStyle(
                  fontFamily: 'Solway',
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                ),
              )
            ])),
      ),
    ); ;
  }
}