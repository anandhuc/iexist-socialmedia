import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';

import 'package:url_launcher/url_launcher.dart';

class DrawerScreen extends StatelessWidget {
   DrawerScreen({Key? key}) : super(key: key);
  final ConstantColors constantColors =ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 270,
      child: Container(
        decoration: BoxDecoration(
            color: constantColors.darkColor),
        child: Column(
          children: [
            SizedBox(
              height: 65,
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(22, 42, 37, 37),
                ),
                child: Center(
                  child: Text("iExist",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: constantColors.whiteColor))
                             
                ),
              ),
            ),
            ListTile(

                // leading: const Icon(Icons.share, size: 35),
                title: Text('Terms and Conditions',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 20,
                    )),
                trailing: const Icon(Icons.arrow_right_sharp),
                onTap: () {
                 termsAndConditionsUrllaunch(); 
                }),
            ListTile(
              // leading: const Icon(
              //   Icons.whatsapp,
              // size: 35,
              // ),
              title: Text("Privacy Policy",
                  style: TextStyle(
                    fontSize: 20,
                    color: constantColors.whiteColor,
                  )),
              onTap: () {
                privacyUrllaunch();
              },
            ),
            ListTile(
              // leading: const Icon(
              //   Icons.star_border_outlined,
              //   size: 35,
              // ),
              title: Text("About Us",
                  style: TextStyle(
                    fontSize: 20,
                    color: constantColors.whiteColor,
                  )),
              onTap: () {
                aboutUsUrllaunch();
              },
            ),
            ListTile(
              // leading: const Icon(
              //   Icons.logout,
              //   size: 35,
              // ),
              title: Text("Exit ",
                  style: TextStyle(
                    fontSize: 20,
                    color: constantColors.whiteColor, 
                    
                  )),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
            Spacer(
              flex: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Version',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 119, 119, 119),
                        letterSpacing: 2),
                  ),
                  Text(
                    '1.0.0',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 119, 119, 119),
                        letterSpacing: 2),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void termsAndConditionsUrllaunch() async {
    final Uri _url = Uri.parse(
        'https://docs.google.com/document/d/1AENp6aCeosnAEsQnpIEt1yo9X3L1bxccV6FdV_D0ZOg/edit?usp=share_link');

    if (await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  void aboutUsUrllaunch() async {
    final Uri _url = Uri.parse(
        'https://docs.google.com/document/d/12kJmNWzxXj_NNVOalS12sIAESt_gFB5E9B0JfhxWfs0/edit?usp=share_link');

    if (await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  void privacyUrllaunch() async {
    final Uri _url = Uri.parse(
        'https://docs.google.com/document/d/1BJpq9YhIX8Be6iP2ZgAbAL_r1J-uRDlOEa7SaRMw7Gs/edit?usp=share_link');

    if (await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
