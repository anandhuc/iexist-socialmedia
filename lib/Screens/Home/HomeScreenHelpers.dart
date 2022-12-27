import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:provider/provider.dart';

class HomeScreenHelpers with ChangeNotifier{
  ConstantColors constantColors =ConstantColors();

 Widget bottomNavBar(BuildContext context, int index,PageController pageController){
  return CustomNavigationBar(
    currentIndex: index,
    bubbleCurve: Curves.bounceIn,
    scaleCurve: Curves.decelerate,
    selectedColor: constantColors.blueColor,
    unSelectedColor:constantColors.whiteColor ,
    strokeColor: constantColors.blueColor,
    scaleFactor: 0.5,
    iconSize: 30.0,
    onTap: (value) {
      index =value;
      pageController.jumpToPage(value);
      notifyListeners();
    },
    backgroundColor:Color(0xff040307) ,
    items:[
      CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
    CustomNavigationBarItem(icon: Icon(EvaIcons.messageSquare)),
   CustomNavigationBarItem(icon: CircleAvatar(
    radius: 35,
    backgroundColor: constantColors.blueGreyColor,
     backgroundImage: NetworkImage(Provider.of<FirebaseOpretions>(context, listen: false).initUserImage.toString()) 
   ))
   
    
    ]);
 }

}