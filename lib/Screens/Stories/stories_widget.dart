import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/Home/screenHome.dart';
import 'package:i_exist_1/Screens/Stories/stories_helper.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class StoryWidgets {
  final ConstantColors constantColors = ConstantColors();
  final TextEditingController storyHighlightTitleController =
      TextEditingController();

  addStory(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Provider.of<StoriesHelper>(context, listen: false)
                            .selectStoryImage(context, ImageSource.gallery)
                            .whenComplete(() {
                          // Navigator.pop(context);
                        });
                      }),
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Provider.of<StoriesHelper>(context, listen: false)
                            .selectStoryImage(context, ImageSource.camera)
                            .whenComplete(() {
                          Navigator.pop(context);
                        });
                      })
                ],
              )
            ],
          ),
        );
      },
    );
  }

  previewStoryImage(BuildContext context, File storyImage) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: constantColors.darkColor),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.file(storyImage),
              ),
              Positioned(
                  top: 700,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                            heroTag: 'Reselect image',
                            backgroundColor: constantColors.redColor,
                            child: Icon(
                              FontAwesomeIcons.deleteLeft,
                              color: constantColors.whiteColor,
                            ),
                            onPressed: () {
                              addStory(context);
                            }),
                        FloatingActionButton(
                            heroTag: 'Conform image',
                            backgroundColor: constantColors.blueColor,
                            child: Icon(
                              FontAwesomeIcons.check,
                              color: constantColors.whiteColor,
                            ),
                            onPressed: () {
                              Provider.of<StoriesHelper>(context, listen: false)
                                  .uploadStoryImage(context)
                                  .whenComplete(() async {
                                    //  Navigator.pushReplacement(
                                    //     context,
                                    //     PageTransition(
                                    //         child: ScreenHome(),
                                    //         type: PageTransitionType
                                    //             .bottomToTop)); 
                                try {
                                  await FirebaseFirestore.instance 
                                      .collection('stories')
                                      .doc(Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid)
                                      .set({
                                    'image': Provider.of<StoriesHelper>(context,
                                            listen: false)
                                        .getStoryImageUrl,
                                    'username': Provider.of<FirebaseOpretions>(
                                            context,
                                            listen: false)
                                        .initUserName,
                                    'userimage': Provider.of<FirebaseOpretions>(
                                            context,
                                            listen: false)
                                        .initUserImage,
                                    'time': Timestamp.now(),
                                    'useruid': Provider.of<Authentication>(
                                            context,
                                            listen: false) 
                                        .getUserUid
                                  }).whenComplete(() async{
                                   await Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: ScreenHome(),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  });
                                } catch (e) {
                                  print(e.toString());
                                }
                              });
                            })
                      ],
                    ),
                  ))
            ],
          ),
        );
      },
    );
  }

  // addToHighlights(BuildContext context, String storyImage) {
  //   return showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (context) {
  //       return Padding(
  //         padding:
  //             EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  //         child: Container(
  //           height: MediaQuery.of(context).size.height * 0.37,
  //           width: MediaQuery.of(context).size.width,
  //           decoration: BoxDecoration(
  //             color: constantColors.darkColor,
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 150),
  //                 child: Divider(
  //                   thickness: 4.0,
  //                   color: constantColors.whiteColor,
  //                 ),
  //               ),
  //               Text(
  //                 'Add to Existing Album',
  //                 style: TextStyle(
  //                     color: constantColors.whiteColor,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.1,
  //                 width: MediaQuery.of(context).size.width,
  //                 child: StreamBuilder<QuerySnapshot>(
  //                   stream: FirebaseFirestore.instance
  //                       .collection('users')
  //                       .doc(Provider.of<Authentication>(context, listen: false)
  //                           .getUserUid)
  //                       .collection('highlights')
  //                       .snapshots(),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.connectionState == ConnectionState.waiting) {
  //                       return Center(
  //                         child: CircularProgressIndicator(),
  //                       );
  //                     } else {
  //                       return ListView(
  //                           scrollDirection: Axis.horizontal,
  //                           children: snapshot.data!.docs
  //                               .map((DocumentSnapshot documentSnapshot) {
  //                             return GestureDetector(
  //                               onTap: () {
  //                                 Provider.of<StoriesHelper>(context,listen: false).addStoryToExistingAlbum(context, Provider.of<Authentication>(context,listen: false).getUserUid, documentSnapshot.id, storyImage); 
  //                               },
  //                               child: Padding(
  //                                 padding: const EdgeInsets.only(left: 5.0),
  //                                 child: Container(
  //                                   child: Column(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.center,
  //                                     children: [
  //                                       CircleAvatar(
  //                                           backgroundColor:
  //                                               constantColors.transperent,
  //                                           backgroundImage: NetworkImage(
  //                                               documentSnapshot['cover']),
  //                                           radius: 25),
  //                                       Text(
  //                                         documentSnapshot['title'],
  //                                         style: TextStyle(
  //                                             fontWeight: FontWeight.normal,
  //                                             fontSize: 12,
  //                                             color: constantColors.whiteColor),
  //                                       )
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ),
  //                             );
  //                           }).toList());
  //                     }
  //                   },
  //                 ),
  //               ),
  //               Text(
  //                 'Create New Album',
  //                 style: TextStyle(
  //                     color: constantColors.whiteColor,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.1,
  //                 width: MediaQuery.of(context).size.width,
  //                 child: StreamBuilder<QuerySnapshot>(
  //                   stream: FirebaseFirestore.instance
  //                       .collection('chatroomIcons')
  //                       .snapshots(),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.connectionState == ConnectionState.waiting) {
  //                       return Center(
  //                         child: CircularProgressIndicator(),
  //                       );
  //                     } else {
  //                       return ListView(
  //                         scrollDirection: Axis.horizontal,
  //                         children: snapshot.data!.docs
  //                             .map((DocumentSnapshot documentSnapshot) {
  //                           return GestureDetector(
  //                             onTap: () {
  //                               Provider.of<StoriesHelper>(context,
  //                                       listen: false)
  //                                   .convertHighlightedIcon(
  //                                       documentSnapshot['image']);
  //                             },
  //                             child: Container(
  //                               height: 50,
  //                               width: 50,
  //                               child: Image.network(documentSnapshot['image']),
  //                             ),
  //                           );
  //                         }).toList(),
  //                       );
  //                     }
  //                   },
  //                 ),
  //               ),
  //               Container(
  //                 height: MediaQuery.of(context).size.height * 0.1,
  //                 width: MediaQuery.of(context).size.width,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     SizedBox(
  //                       width: MediaQuery.of(context).size.width * 0.7,
  //                       child: TextField(
  //                         textCapitalization: TextCapitalization.words,
  //                         controller: storyHighlightTitleController,
  //                         style: TextStyle(
  //                             color: constantColors.whiteColor,
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.normal),
  //                         decoration: InputDecoration(
  //                           hintText: 'Add Album Title...',
  //                           hintStyle: TextStyle(
  //                               color: constantColors.whiteColor,
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.normal),
  //                         ),
  //                       ),
  //                     ),
  //                     FloatingActionButton(
  //                         backgroundColor: constantColors.blueColor,
  //                         child: Icon(
  //                           FontAwesomeIcons.check,
  //                           color: constantColors.whiteColor,
  //                         ),
  //                         onPressed: () {
  //                           if (storyHighlightTitleController.text.isNotEmpty) {
  //                             Provider.of<StoriesHelper>(context, listen: false)
  //                                 .addStoryToNewAlbum(
  //                                     context,
  //                                     Provider.of<Authentication>(context,
  //                                             listen: false)
  //                                         .getUserUid,
  //                                     storyHighlightTitleController.text,
  //                                     storyImage);
  //                           } else {
  //                             showModalBottomSheet(
  //                               context: context,
  //                               builder: (context) {
  //                                 return Container(
  //                                   height: 50,
  //                                   decoration: BoxDecoration(
  //                                       color: constantColors.darkColor,
  //                                       borderRadius: BorderRadius.only(
  //                                           topLeft: Radius.circular(12),
  //                                           topRight: Radius.circular(12))),
  //                                   child: Column(
  //                                     children: [
  //                                       Padding(
  //                                         padding: const EdgeInsets.symmetric(
  //                                             horizontal: 150),
  //                                         child: Divider(
  //                                           thickness: 4.0,
  //                                           color: constantColors.whiteColor,
  //                                         ),
  //                                       ),
  //                                       Center(
  //                                         child: Text(
  //                                           'Please name the album...',
  //                                           style: TextStyle(
  //                                               color:
  //                                                   constantColors.whiteColor,
  //                                               fontSize: 14,
  //                                               fontWeight: FontWeight.bold),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 );
  //                               },
  //                             );
  //                           }
  //                         })
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  previewAllHighlights(BuildContext context, String higlightTitle) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserUid)
                .collection('highlights')
                .doc(higlightTitle)
                .collection('stories')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return PageView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot documentSnapshot) {
                    return Container(
                      color: constantColors.darkColor,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(documentSnapshot['image']),
                    );
                  }).toList(),
                );
              }
            },
          ),
        );
      },
    );
  }
}
