import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/AltProfile/alt_Profile.dart';
import 'package:i_exist_1/Screens/Home/screenHome.dart';
import 'package:i_exist_1/Screens/Messaging/directMessaging/directMessageing.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:i_exist_1/Utils/PostOptions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AltProfileHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      leading: IconButton(
        onPressed: (() {
          Navigator.pop(
              context,
              PageTransition(
                  child: const ScreenHome(),
                  type: PageTransitionType.bottomToTopPop));
        }),
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          color: constantColors.whiteColor,
        ),
      ),
      centerTitle: true,
      title: RichText(
          text: TextSpan(
              text: "i",
              style: TextStyle(
                fontFamily: 'Solway',
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              children: <TextSpan>[
            TextSpan(
              text: 'Exist',
              style: TextStyle(
                fontFamily: 'Solway',
                color: constantColors.blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            )
          ])),
      actions: [
        IconButton(
          onPressed: (() {
            // Navigator.pop(
            //     context,
            //     PageTransition(
            //         child: const ScreenHome(),
            //         type: PageTransitionType.bottomToTopPop));
          }),
          icon: Icon(
            EvaIcons.moreVertical,
            color: constantColors.whiteColor,
          ),
        ),
      ],
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25,
        width: 350,
        child: Divider(
          color: constantColors.whiteColor,
        ),
      ),
    );
  }

  Widget headerProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                // color: constantColors.blueColor ,
                height: 200,
                width: 180,
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: constantColors.transperent,
                        radius: 60,
                        backgroundImage:
                            NetworkImage(snapshot.data!['userimage']),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0 ), 
                      child: Text(
                        snapshot.data!['username'],
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            EvaIcons.emailOutline,
                            size: 15,
                            color: constantColors.whiteColor,
                          ),
                          Text(
                            snapshot.data!['useremail'],
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width *0.5 , 
                // color: constantColors.redColor ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround ,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              checkFollowersSheet(context, snapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: constantColors.darkColor,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 70,
                              width: 70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data!['useruid'])
                                        .collection('followers')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28),
                                        );
                                      }
                                    },
                                  ),
                                  Text("Followers",
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              checkFollowingSheet(context, snapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: constantColors.darkColor,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 70,
                              width: 70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data!['useruid'])
                                        .collection('following')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28),
                                        );
                                      }
                                    },
                                  ),
                                  Text("Following",
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 13.0),
                      child: Container(
                              decoration: BoxDecoration(
                                  color: constantColors.darkColor,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 70,
                              width: 70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<QuerySnapshot>( 
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data!['useruid'])
                                        .collection('posts')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28),
                                        );
                                      }
                                    },
                                  ),
                                  Text("Posts",
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))
                                ],
                              ),
                            ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05 ,
            width: MediaQuery.of(context).size.width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .036,
                    width: MediaQuery.of(context).size.width * .45,
                    child: MaterialButton(
                      color: constantColors.blueColor,
                      onPressed: () {
                        Provider.of<FirebaseOpretions>(context, listen: false)
                            .followUser(
                                userUid,
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                {
                                  'username': Provider.of<FirebaseOpretions>(
                                          context,
                                          listen: false)
                                      .initUserName,
                                  'userimage': Provider.of<FirebaseOpretions>(
                                          context,
                                          listen: false)
                                      .initUserImage,
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserUid,
                                  'useremail': Provider.of<FirebaseOpretions>(
                                          context,
                                          listen: false)
                                      .initUserEmail,
                                  'time': Timestamp.now()
                                },
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                userUid,
                                {
                                  'username': snapshot.data!['username'],
                                  'userimage': snapshot.data!['userimage'],
                                  'useremail': snapshot.data!['useremail'],
                                  'useruid': snapshot.data!['useruid'],
                                  'time': Timestamp.now()
                                })
                            .whenComplete(() {
                          followerNotification(
                              context, snapshot.data!['username']);
                        });
                      },
                      child: Text(
                        'Follow',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: constantColors.whiteColor),
                      ),
                    ),
                  ),
                  // SizedBox( 
                  //   height: MediaQuery.of(context).size.height * .036,
                  //   width: MediaQuery.of(context).size.width * .60,  
                  //   child: MaterialButton(
                  //     color: constantColors.blueColor,
                  //     onPressed: () {
                  //       Navigator.push(context, PageTransition(child: ScreenDMessageing(reciversname:snapshot.data!['username'],reciversimage: snapshot.data!['userimage'], ), type: PageTransitionType.rightToLeft)); 
                  //     }, 
                  //     child: Text(
                  //       'messege',
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: constantColors.whiteColor),
                  //     ),
                  //   ),
                  // ),
                ]),
          )
        ],
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start ,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  FontAwesomeIcons.userAstronaut,
                  color: constantColors.yellowColor,
                ),
              ),
              Text(
                "Recently Added",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: constantColors.whiteColor),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15)),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!['useruid'])
                  .collection('following')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else { 
                  return ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: constantColors.darkColor,
                              backgroundImage:
                                  NetworkImage(documentSnapshot['userimage']),
                            ),
                          );
                        }
                      }).toList());
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.469 ,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: constantColors.darkColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(15)),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(snapshot.data['useruid'])
            .collection('posts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0), 
              child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot documentSnapshot) {
                    return InkWell(
                      onTap: () => showPostDetails(context, documentSnapshot),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: constantColors.whiteColor,
                            borderRadius: BorderRadius.circular(5)),
                        
                          child: FittedBox(
                            child: Image.network(documentSnapshot['postimage']),
                          ),
                      
                      ),
                    );
                  }).toList()),
            );
          }
        },
      ),
    );
  }

  followerNotification(BuildContext context, String name) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Text(
                  'Followed $name',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  checkFollowingSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!['useruid'])
                .collection('following')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot documentSnapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: AltProfile(
                                    useruid: documentSnapshot['useruid']),
                                type: PageTransitionType.bottomToTop));
                      },
                      leading: CircleAvatar(
                        backgroundColor: constantColors.blueGreyColor,
                        backgroundImage:
                            NetworkImage(documentSnapshot['userimage']),
                      ),
                      title: Text(
                        documentSnapshot['username'],
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      subtitle: Text(
                        documentSnapshot['useremail'],
                        style: TextStyle(
                            color: constantColors.yellowColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                      trailing: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Unfollow',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )),
                    );
                  }
                }).toList());
              }
            },
          ),
        );
      },
    );
  }

  checkFollowersSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!['useruid'])
                .collection('followers')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot documentSnapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: AltProfile(
                                    useruid: documentSnapshot['useruid']),
                                type: PageTransitionType.bottomToTop));
                      },
                      leading: CircleAvatar(
                        backgroundColor: constantColors.blueGreyColor,
                        backgroundImage:
                            NetworkImage(documentSnapshot['userimage']),
                      ),
                      title: Text(
                        documentSnapshot['username'],
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      subtitle: Text(
                        documentSnapshot['useremail'],
                        style: TextStyle(
                            color: constantColors.yellowColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                      trailing: documentSnapshot['useruid'] ==
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid
                          ? SizedBox()
                          : TextButton(
                              onPressed: () {},
                              child: Text(
                                'Unfollow',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )),
                    );
                  }
                }).toList());
              }
            },
          ),
        );
      },
    );
  }

  showPostDetails(BuildContext context,DocumentSnapshot documentSnapshot){
    return showModalBottomSheet(context: context, builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor,
          borderRadius: BorderRadius.circular(12),
          
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
            Container(
              height: MediaQuery.of(context).size.height * 0.4, 
        width: MediaQuery.of(context).size.width,
        child: FittedBox(
          child: Image.network(documentSnapshot['postimage']),
        ),

            ),
            Text(documentSnapshot['caption'],style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.normal,
              fontSize: 22 
            ),) 
            ,
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround ,
                    children: [
                      Container(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showLikes(
                                        context, documentSnapshot['caption']);
                              },
                              onTap: () {
                                print('Adding like.................');
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .addLike(
                                        context,
                                        documentSnapshot['caption'],
                                        Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid
                                            .toString());
                              },
                              child: Icon(
                                FontAwesomeIcons.heart,
                                color: constantColors.redColor,
                                size: 22,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(documentSnapshot['caption'])
                                  .collection('likes')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                     
                      Container(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center ,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // adding comment============================>>>
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showCommentSheet(context, documentSnapshot,
                                        documentSnapshot['caption']);
                              },
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: constantColors.blueColor,
                                size: 22,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(documentSnapshot['caption'])
                                  .collection('comments')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }
                              },
                            ) 
                          ],
                          
                        ),
                      ),
                      // Spacer(),
                    ], 
                  ),
            )

          ],
        ),
      );
    },);
  }
}
