import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/Home/screenHome.dart';
import 'package:i_exist_1/Screens/Landing_Page/landingUtils.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingService with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.32 ,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.transparent,
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .userAvatar),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: const Text("Reselect"),
                          onPressed: () {
                            Provider.of<LandingUtils>(context, listen: false)
                                .pickUserAvatar(context, ImageSource.gallery);
                          }),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: const Text("conform image"),
                          onPressed: () {
                            Provider.of<FirebaseOpretions>(context,
                                    listen: false)
                                .uploadUserAvatar(context)
                                .whenComplete(() {
                              signInSheet(context);
                            });
                          })
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("users").get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
              return ListTile(
                onTap: () {
                  Provider.of<Authentication>(context, listen: false)
                      .logIntoAccount(documentSnapshot['useremail'],
                          documentSnapshot['userpassword'])
                      .whenComplete(() => {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: ScreenHome(),
                                    type: PageTransitionType.bottomToTop))
                          });
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(documentSnapshot['userimage']),
                  backgroundColor: constantColors.darkColor,
                ),
                title: Text(documentSnapshot['username']),
                subtitle: Text(
                  documentSnapshot['useremail'],
                ),



                // to delete log in data from passwordless log in=======================>>
                trailing: IconButton(
                    onPressed: (() {
                      Provider.of<FirebaseOpretions>(context, listen: false)
                          .deleteUserData(documentSnapshot['userUid'],'users'); 
                    }),
                    icon: Icon(
                      Icons.delete,
                      color: constantColors.whiteColor,
                    )),
              );
            }).toList());
          }
        },
      ),
    );
  }

  logInsheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: userEmailController,
                    decoration: const InputDecoration(
                      hintText: "useremail",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: userPasswordController,
                    decoration: const InputDecoration(
                      hintText: "password",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                    backgroundColor: constantColors.redColor,
                    onPressed: () {
                      if (userEmailController.text.isNotEmpty ||
                          userPasswordController.text.isNotEmpty) {
                        Provider.of<Authentication>(context, listen: false)
                            .logIntoAccount(userEmailController.text,
                                userPasswordController.text)
                            .whenComplete(() {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: const ScreenHome(),
                                  type: PageTransitionType.leftToRight));
                        });
                      } else {
                        print("no values in feilds");
                      }
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .getuserAvatar),
                  backgroundColor: Colors.red,
                  radius: 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      hintText: "username",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: userEmailController,
                    decoration: const InputDecoration(
                      hintText: "useremail",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: userPasswordController,
                    decoration: const InputDecoration(
                      hintText: "passworde",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FloatingActionButton(onPressed: () {
                  if (userEmailController.text.isNotEmpty ||
                      userPasswordController.text.isNotEmpty) {
                    Provider.of<Authentication>(context, listen: false)
                        .createAccount(userEmailController.text,
                            userPasswordController.text)
                        .whenComplete(() {
                      print("Creating collection");
                      Provider.of<FirebaseOpretions>(context, listen: false)
                          .createUserCollection(context, {
                        'userpassword': userNameController.text,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .userUid,
                        'useremail': userEmailController.text,
                        'username': userNameController.text,
                        'userimage':
                            Provider.of<LandingUtils>(context, listen: false)
                                .getuserAvatarUrl
                      });
                    }).whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: const ScreenHome(),
                              type: PageTransitionType.leftToRight));
                    });
                  } else {
                    print("no values in feilds");
                  }
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
