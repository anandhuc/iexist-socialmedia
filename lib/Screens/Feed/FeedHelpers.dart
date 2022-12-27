// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/AltProfile/alt_Profile.dart';
import 'package:i_exist_1/Screens/Stories/stories.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:i_exist_1/Utils/PostOptions.dart';
import 'package:i_exist_1/Utils/Uploadpost.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor.withOpacity(0.6),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImageType(context);
            },
            icon: Icon(
              Icons.camera_enhance_rounded,
              color: constantColors.greenColor,
            ))
      ],
      title: RichText(
          text: TextSpan(
              text: "Feed ",
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Solway',
                  fontSize: 20),
              children: <TextSpan>[
            TextSpan(
                text: "Existance.",
                style: TextStyle(
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20))
          ])),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 5, right: 5),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.darkColor,
                  borderRadius: BorderRadius.circular(30)),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stories')
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Stories(
                                          documentSnapshot: documentSnapshot),
                                      type: PageTransitionType.topToBottom));
                            },
                            child: Container(
                              height: 30,
                              width: 50,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          documentSnapshot['userimage'])),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: constantColors.blueColor,
                                      width: 2)),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  // color: constantColors.darkColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18))),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        height: 500,
                        width: 400,
                        child:
                            Lottie.asset('lib/Assets/animations/blueball.json'),
                      ),
                    );
                  } else {
                    return loadPost(context, snapshot);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        //  var a= documentSnapshot.data();

        //  print("document feed help============>");
        //  print(a.runtimeType );
        //  print(documentSnapshot['userimage']);
        //  print(documentSnapshot['postimage']);
        Provider.of<PostFunctions>(context, listen: false)
            .showPostTimeAgo(documentSnapshot['time']);

        return Padding(
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
            bottom: 5,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: constantColors.darkColor,
            ),
            height: MediaQuery.of(context).size.height * 0.7   ,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (documentSnapshot['useruid'] !=
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid) {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: AltProfile(
                                          useruid: documentSnapshot['useruid']),
                                      type: PageTransitionType.bottomToTop));
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: constantColors.redColor,
                            radius: 20,
                            backgroundImage:
                                NetworkImage((documentSnapshot['userimage'])),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // child: Text("username",style: TextStyle(color: constantColors.whiteColor,fontSize: 20 ),),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  documentSnapshot['username'],
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 20),
                                ),
                              ),
                              // child: Text(documentSnapshot['caption'], style: TextStyle(color: constantColors.whiteColor,fontSize: 20 ),),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: RichText(
                                  text: TextSpan(
                                      // text: documentSnapshot['useremail'],
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                '${Provider.of<PostFunctions>(context, listen: false).getImageTimePosted.toString()}',
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 10))
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid ==
                              documentSnapshot['useruid']
                          ? IconButton(
                              onPressed: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showPostOptions(
                                        context, documentSnapshot['caption']);
                              },
                              icon: Icon(
                                EvaIcons.moreHorizontalOutline,
                                color: constantColors.whiteColor,
                              ))
                          // : SizedBox() 
                          :
                          IconButton(
                              onPressed: () {
                                
  showDialog(context: context,
                                  builder: (context,) => 
                                   AlertDialog(
                                    backgroundColor: constantColors.darkColor, 
                                    actions: [ 
                                      Row(mainAxisAlignment: MainAxisAlignment.end, 
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },  
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                    color:
                                                        constantColors.whiteColor,
                                                    fontSize: 16),
                                              )),
                                          MaterialButton(
                                              color: constantColors.redColor,
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color:
                                                        constantColors.whiteColor,
                                                    fontSize: 16),
                                              ),
                                              onPressed: () { 
                                                Provider.of<PostFunctions>(context,listen: false).reportPostData(documentSnapshot['caption'], true);
                                                Navigator.pop(context); 
                                              })
                                        ],
                                      )
                                    ],
                                    content: Text(
                                      'Think this post is unSocial ?',
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize:16),
                                    ),
                                  ),
                                );
  

                               
                              },
                              icon: Icon(
                                Icons.report_outlined,
                                color: constantColors.whiteColor,
                                size: 25,
                              ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.46,
                      width: MediaQuery.of(context).size.width,
                      // decoration:BoxDecoration(image: DecorationImage(image:NetworkImage((documentSnapshot['userimage']  )) ))   ,
                      decoration: BoxDecoration(
                          color: constantColors.instaColor,
                          image: DecorationImage(
                              image:
                                  NetworkImage((documentSnapshot['postimage'])),
                              fit: BoxFit.contain)),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.start,
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
                      Spacer(),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        documentSnapshot['username'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: constantColors.whiteColor,
                            fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(documentSnapshot['caption'],
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 15)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }



 
}
