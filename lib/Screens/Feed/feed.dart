import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/Feed/FeedHelpers.dart';
import 'package:i_exist_1/Widgets/drawer.dart';
import 'package:provider/provider.dart';

class ScreenFeed extends StatelessWidget {
  ScreenFeed({super.key});
  ConstantColors constantColors= ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      drawer: DrawerScreen(),
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(50), 
        child: Provider.of<FeedHelpers>(context,listen: false).appBar(context)) ,
    body: Provider.of<FeedHelpers>(context,listen: false).feedBody(context) , 
    
    );
  }
}