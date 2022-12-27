import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_exist_1/Screens/AltProfile/alt_Profile.dart';
import 'package:i_exist_1/Screens/Landing_Page/landingPage.dart';
import 'package:i_exist_1/Screens/Stories/stories_widget.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Utils/PostOptions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final StoryWidgets storyWidgets =StoryWidgets();

  Widget headerProfile(BuildContext context, dynamic snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Row(
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
                  onTap: () {
                    storyWidgets.addStory(context); 
                  },

                  
                  child: Stack(
                    children:[ CircleAvatar(
                      backgroundColor: constantColors.transperent,
                      radius: 60,
                      backgroundImage:
                          NetworkImage(snapshot.data.data()['userimage']),
                    ),

                    Positioned(
                      top: 90,
                      left: 90,
                      child: Icon(FontAwesomeIcons.circlePlus, color: constantColors.whiteColor,)) 
                    
                    ]
                  ),
                ),
                Text(
                  snapshot.data.data()['username'],
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        EvaIcons.emailOutline,
                        size: 15   ,
                        color: constantColors.whiteColor,
                      ),
                      Text(
                        snapshot.data.data()['useremail'],
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
            // width: MediaQuery.of(context).size.width*.098 ,
            // color: constantColors.redColor ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround, 
              crossAxisAlignment: CrossAxisAlignment.center  ,  
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => checkFollowersSheet(context, snapshot), 
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
                      SizedBox(width: 5,),  
                      InkWell(
                        onTap: () => checkFollowingSheet(context, snapshot), 
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
                  child:  Container(
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
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25,
        width: 350,
        child: Divider(
          color: constantColors.darkColor,
        ),
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // crossAxisAlignment: CrossAxisAlignment.start ,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0) ,
                      child: Icon(
                        FontAwesomeIcons.userAstronaut,
                        color: constantColors.yellowColor,
                      ),
                    ),
                    Text(
                      "Recently Added" ,
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
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     height: MediaQuery.of(context).size.height * 0.09 ,
              //     width: MediaQuery.of(context).size.width,
              //     decoration: BoxDecoration(
              //         color: constantColors.darkColor.withOpacity(0.4),
              //         borderRadius: BorderRadius.circular(15)),
              //     child: StreamBuilder<QuerySnapshot>(
              //       stream: FirebaseFirestore.instance
              //           .collection('users')
              //           .doc(Provider.of<Authentication>(context,listen: false).getUserUid)
              //           .collection('highlights') 
              //           .snapshots(),
              //       builder: (context, snapshot) {
              //         if (snapshot.connectionState == ConnectionState.waiting) {
              //           return Center(
              //             child: CircularProgressIndicator(),
              //           );
              //         } else {
              //           return ListView(
              //             scrollDirection: Axis.horizontal  ,
              //             children: snapshot.data!.docs
              //                 .map((DocumentSnapshot documentSnapshot) {
              //               if (snapshot.connectionState ==
              //                   ConnectionState.waiting) {
              //                 return CircularProgressIndicator();
              //               } else {
             
              //                 return GestureDetector(
              //                   onTap: () { 
              //                     storyWidgets.previewAllHighlights(context, documentSnapshot['title']);
              //                   },

              //                   child: Padding(
              //                     padding: const EdgeInsets.only(left:5.0),
              //                     child: Container(
              //                      child: Column(
              //                         mainAxisAlignment: MainAxisAlignment.center,
              //                         crossAxisAlignment: CrossAxisAlignment.center,
              //                         children: [
              //                           CircleAvatar(
              //                             backgroundColor: constantColors.transperent, 
              //                             backgroundImage: NetworkImage(documentSnapshot['cover']),
              //                             radius: 25   
              //                           ),
              //                           Text(documentSnapshot['title'], style: TextStyle(
              //                                             fontWeight: FontWeight.normal,
              //                                             fontSize: 12, 
              //                                             color: constantColors.whiteColor),)
                                
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 );
              //               }
              //             }).toList(),
              //           );
              //         }
              //       },
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
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
                      crossAxisCount: 3) ,
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot documentSnapshot) {
                    return InkWell(  
                      onTap: () => showPostDetails(context, documentSnapshot),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: constantColors.whiteColor ,
                            borderRadius: BorderRadius.circular(5)),
                            child: FittedBox(
                              child: Image.network(documentSnapshot['postimage'])  ,  
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

  logOutDilogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            "Log Out ?",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                MaterialButton(
                    color: constantColors.redColor,
                    child: Text(
                      'Yep',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Provider.of<Authentication>(context, listen: false)
                          // .logOutViaEmail()
                          .signOutWithGoogle()
                          .whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: ScreenLandingPage(),
                                type: PageTransitionType.fade));
                      });
                    })
              ],
            )
          ],
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
}
