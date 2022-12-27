import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/ChatRoom/chatRoom.dart';
import 'package:i_exist_1/Screens/Feed/feed.dart';
import 'package:i_exist_1/Screens/Home/HomeScreenHelpers.dart';
import 'package:i_exist_1/Screens/Profile/profile.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:provider/provider.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  ConstantColors constantColors = ConstantColors();
  final PageController homePageController = PageController();
  int pageIndex = 0;
  
  @override        
  void initState() {
    Provider.of<FirebaseOpretions>(context, listen: false)
        .initUserData(context);
        
    super.initState();
  }
  
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constantColors.darkColor,
        body: PageView(
          controller: homePageController,
          children: [ScreenFeed(), ScreenChatRoom(), ScreenProfile()],
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: ((page) {
            setState(() {
              pageIndex = page;
              Provider.of<FirebaseOpretions>(context, listen: false)
        .initUserData(context); 
            });
          }),
        ),
        bottomNavigationBar:
            Provider.of<HomeScreenHelpers>(context, listen: false)
                .bottomNavBar(context, pageIndex , homePageController));
  }
}
