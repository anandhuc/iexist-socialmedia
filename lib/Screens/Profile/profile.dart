import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/Landing_Page/landingPage.dart';
import 'package:i_exist_1/Screens/Profile/profileHelpers.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ScreenProfile extends StatelessWidget {
  ScreenProfile({super.key});
  ConstantColors constantColors = ConstantColors();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              EvaIcons.settings2Outline,
              color: constantColors.whiteColor,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ProfileHelpers>(context, listen: false)
                    .logOutDilogue(context);
              },
              icon: Icon(
                EvaIcons.logOut,
                color: constantColors.whiteColor,
              ))
        ],
        centerTitle: true,
        backgroundColor: constantColors.blueGreyColor,
        title: RichText(
            text: TextSpan(
                text: "My",
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Solway',
                    fontSize: 20),
                children: <TextSpan>[
              TextSpan(
                  text: "Profile",
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))
            ])),
      ),
      
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // ignore: sort_child_properties_last
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .getUserUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .headerProfile(context, snapshot),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .divider(),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .middleProfile(context, snapshot),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .footerProfile(context, snapshot)
                    ],
                  );
                }
              },
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: constantColors.blueGreyColor.withOpacity(0.6)),
          ),
        ),
      ),
    );
  }
}
