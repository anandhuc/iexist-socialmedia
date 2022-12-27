import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/Home/screenHome.dart';
import 'package:i_exist_1/Screens/Landing_Page/landingServices.dart';
import 'package:i_exist_1/Screens/Landing_Page/landingUtils.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .65,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image:
              DecorationImage(image: AssetImage("lib/Assets/pngs/login.png"))),
    );

  }


   Widget mainTagLine(BuildContext context) {
    return Positioned(
        top: 470,
        left: 10.0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 170.0),
          child: RichText(
              text: TextSpan(
                  text: "Do ",
                  style: TextStyle(
                    fontFamily: 'Solway',
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                  children: <TextSpan>[
                TextSpan(
                  text: 'You ',
                  style: TextStyle(
                    fontFamily: 'Solway',
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                ),
                TextSpan(
                  text: 'Exist ?',
                  style: TextStyle(
                    fontFamily: 'Solway',
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                )
              ])),
        ));
  }

   Widget mainButtons(BuildContext context) {
    return Positioned(
        top: 630.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  print("object");
                  emailAuthSheet(context);
                },
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.yellowColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    EvaIcons.emailOutline,
                    color: constantColors.yellowColor,
                    
                   ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("Signing in google");
                  Provider.of<Authentication>(context, listen: false)
                      .signInwithGoogle()
                      .whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: ScreenHome(),
                            type: PageTransitionType.fade));
                  });  
                },
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.redColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    EvaIcons.google,
                    color: constantColors.redColor,
                  ),
                ),
              ),
              GestureDetector(
                // onTap: () => , 
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.blueColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    EvaIcons.facebook,
                    color: constantColors.blueColor,
                  ),
                ),
              )
            ],
          ),
        ));
  }


  Widget privacyText(BuildContext context) {
    return Positioned(
        top: 740,
        left: 20,
        right: 20,
        child: Container(
          child: Column(
            children: const [
              Text(
                "By continuing you agree iExist's Terms of",
                style: TextStyle(
                    color: Color.fromARGB(255, 89, 88, 88), fontSize: 15),
              ),
              Text(
                "Service & Privacy Policy",
                style: TextStyle(
                    color: Color.fromARGB(255, 89, 88, 88), fontSize: 15),
              )
            ],
          ),
        ));
  }



  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: ((context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.12,  
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Column(mainAxisAlignment: MainAxisAlignment.center ,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ), 
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text("Log In"),
                        onPressed: () {
                          Provider.of<LandingService>(context, listen: false)
                              .logInsheet(context);
                        }), 
                    MaterialButton(
                        color: constantColors.redColor,
                        child: Text("Sign in"),
                        onPressed: () { 
                          //  Provider.of<LandingService>(context, listen: false).signInSheet(context);
                          // Provider.of<LandingUtils>(context, listen: false)
                          //     .selectAvatarOptionsSheet(context);
                          Provider.of<LandingUtils>(context,listen: false).selectAvatarOptionsSheet(context); 
                        }),
                  ],
                )
              ],
            ),
          );
        }));
  }



}
