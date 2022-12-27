import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/AltProfile/alt_Profile.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:i_exist_1/Utils/Uploadpost.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  TextEditingController updatedCaptionController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  TextEditingController commentController = TextEditingController();
  String? imageTimePosted;
  String? get getImageTimePosted => imageTimePosted;

  showPostTimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    notifyListeners();
  }

  showPostOptions(BuildContext context, String postId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Edit Caption',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Container(
                                    color: constantColors.blueGreyColor,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: constantColors.blueGreyColor,
                                            width: 300,
                                            height: 60,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Add new Caption...',
                                                hintStyle: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              controller:
                                                  updatedCaptionController,
                                            ),
                                          ),
                                          FloatingActionButton(
                                              backgroundColor:
                                                  constantColors.redColor,
                                              child: Icon(
                                                FontAwesomeIcons.fileArrowUp,
                                                color:
                                                    constantColors.whiteColor,
                                              ),
                                              onPressed: () {
                                                print(
                                                    'caption updated=========>');
                                                Provider.of<FirebaseOpretions>(
                                                        context,
                                                        listen: false)
                                                    .updateCaption(postId, {
                                                  'caption':
                                                      updatedCaptionController
                                                          .text
                                                }).whenComplete(() {
                                                  updatedCaptionController
                                                      .clear();
                                                  notifyListeners();
                                                });
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                      MaterialButton(
                          color: constantColors.redColor,
                          child: Text(
                            'Delete Post',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: constantColors.darkColor,
                                  title: Text('Delete this post ?',
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  actions: [
                                    MaterialButton(
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  constantColors.whiteColor,
                                              color: constantColors.whiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                    MaterialButton(
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                              color: constantColors.redColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          Provider.of<FirebaseOpretions>(
                                                  context,
                                                  listen: false)
                                              .deleteUserData(postId, 'posts')
                                              .whenComplete(
                                            () {
                                              Navigator.pop(context);
                                              notifyListeners();
                                            },
                                          );
                                        }),
                                  ],
                                );
                              },
                            );
                          }),

                      // MaterialButton(
                      // color: constantColors.redColor,
                      // child: Text(
                      //   'Report Post',
                      //   style: TextStyle(
                      //       color: constantColors.whiteColor,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      // onPressed: () {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         backgroundColor: constantColors.darkColor,
                      //         title: Text('Do you find it UnSocial ?',
                      //             style: TextStyle(
                      //                 color: constantColors.whiteColor,
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold)),
                      //         actions: [
                      //           MaterialButton(
                      //               child: Text(
                      //                 'No',
                      //                 style: TextStyle(
                      //                     decoration:
                      //                         TextDecoration.underline,
                      //                     decorationColor:
                      //                         constantColors.whiteColor,
                      //                     color: constantColors.whiteColor,
                      //                     fontSize: 16,
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //               onPressed: () {
                      //                 Navigator.pop(context);
                      //               }),
                      //           MaterialButton(
                      //               child: Text(
                      //                 'Yes',
                      //                 style: TextStyle(
                      //                     color: constantColors.redColor,
                      //                     fontSize: 16,
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //               onPressed: () {

                      //               }),

                      //         ],
                      //       );
                      //     },
                      //   );
                      // })
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future reportPostData(String postId,bool data) async {
    print('reported');
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update({'reported': data});
        
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserName,
      'userid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserImage,
      'useremail':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserEmail,
      'time': Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserName,
      'userid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserImage,
      'useremail':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserEmail,
      'time': Timestamp.now()
    });
  }

  showCommentSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.67,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
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
                  width: 110 ,
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.whiteColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Comments',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.45, 
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(docId)
                        .collection('comments')
                        .orderBy('time')
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
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.17,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: GestureDetector(
                                        child: CircleAvatar(
                                          backgroundColor:
                                              constantColors.darkColor,
                                          backgroundImage: NetworkImage(
                                              documentSnapshot['userimage']),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        documentSnapshot['username'],
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                FontAwesomeIcons.arrowUp,
                                                color: constantColors.blueColor,
                                                size: 12,
                                              )),
                                          Text(
                                            '0',
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                FontAwesomeIcons.reply,
                                                color:
                                                    constantColors.yellowColor,
                                                size: 12,
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: constantColors.blueColor,
                                            size: 12,
                                          )),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        child: Text(
                                          documentSnapshot['comment'],
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: constantColors.whiteColor
                                      .withOpacity(0.2),
                                  indent: 12,
                                  endIndent: 12,
                                )
                              ],
                            ),
                          );
                        }).toList());
                      }
                    },
                  ),
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 300,
                        height: 39,
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: '  Add comment...',
                            hintStyle: TextStyle(
                                color:
                                    constantColors.whiteColor.withOpacity(0.2),
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                          ),
                          controller: commentController,
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          print('Adding comment..................');
                          addComment(context, snapshot['caption'],
                                  commentController.text)
                              .whenComplete(() {
                            commentController.clear();
                            notifyListeners();
                          });
                        },
                        child: Icon(
                          FontAwesomeIcons.comment,
                          color: constantColors.whiteColor,
                        ),
                        backgroundColor: constantColors.greenColor,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
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
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.whiteColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'Likes',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('likes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                        return ListTile(
                          leading: GestureDetector(
                              child: CircleAvatar(
                                  backgroundColor: constantColors.darkColor,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot['userimage']))),
                          title: Text(
                            documentSnapshot['username'],
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            documentSnapshot['useremail'],
                            style: TextStyle(
                                color: constantColors.blueColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList());
                    }
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // showRewards(BuildContext context) {
  //   return showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.20,
  //         width: MediaQuery.of(context).size.width,
  //         decoration: BoxDecoration(
  //             color: constantColors.blueGreyColor,
  //             borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(12), topRight: Radius.circular(12))),
  //         child: Column(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 150),
  //               child: Divider(
  //                 thickness: 4,
  //                 color: constantColors.whiteColor,
  //               ),
  //             ),
  //             Container(
  //               width: 100,
  //               decoration: BoxDecoration(
  //                   border: Border.all(color: constantColors.whiteColor),
  //                   borderRadius: BorderRadius.circular(10)),
  //               child: Center(
  //                 child: Text(
  //                   'Rewards',
  //                   style: TextStyle(
  //                       color: constantColors.blueColor,
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: MediaQuery.of(context).size.height * 0.1,
  //               width: MediaQuery.of(context).size.width,
  //               child: StreamBuilder<QuerySnapshot>(
  //                 stream: FirebaseFirestore.instance
  //                     .collection('awards')
  //                     .snapshots(),
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Center(
  //                       child: CircularProgressIndicator(),
  //                     );
  //                   } else {
  //                     return ListView(
  //                         scrollDirection: Axis.horizontal,
  //                         children: snapshot.data!.docs
  //                             .map((DocumentSnapshot documentSnapshot) {
  //                           return Container(
  //                             height: 50,
  //                             width: 50,
  //                             child: Image.network(documentSnapshot['image']),
  //                           );
  //                         }).toList());
  //                   }
  //                 },
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
