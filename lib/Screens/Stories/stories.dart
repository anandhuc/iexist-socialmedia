import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/Home/screenHome.dart';
import 'package:i_exist_1/Screens/Stories/stories_helper.dart';
import 'package:i_exist_1/Screens/Stories/stories_widget.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Stories extends StatefulWidget {
  Stories({required this.documentSnapshot, super.key});
  final DocumentSnapshot documentSnapshot;
  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final ConstantColors constantColors = ConstantColors();
  final StoryWidgets storyWidgets = StoryWidgets();

  @override
  void initState() {
    Provider.of<StoriesHelper>(context, listen: false)
        .storyTimePosted(widget.documentSnapshot['time']);
    // Provider.of<StoriesHelper>(context, listen: false).addSeenStamp(
    //     context,
    //     widget.documentSnapshot.id,
    //     Provider.of<Authentication>(context, listen: false).getUserUid,
    //     widget.documentSnapshot); 

    Timer(Duration(seconds: 15), () {
      Navigator.pop(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dy > 0) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        widget.documentSnapshot['image'],
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: 30,
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: constantColors.greyColor1,
                          backgroundImage: NetworkImage(
                              widget.documentSnapshot['userimage']),
                          radius: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          color: constantColors.redColor, 
                          width: MediaQuery.of(context).size.width * 0.48,
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.9),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.documentSnapshot['username'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Text(
                                Provider.of<StoriesHelper>(context,
                                        listen: false)
                                    .getstoryTime,
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid ==
                              widget.documentSnapshot['useruid']
                          ? GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                height: 30,
                                width: 50, 
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [

                                     IconButton(
                            onPressed: () {
                              showMenu(
                                  color: constantColors.transperent,
                                  context: context,
                                  position:
                                      const RelativeRect.fromLTRB(300, 70, 0, 0),
                                  items: [
                                    
                                    PopupMenuItem(
                                        child: ElevatedButton.icon(
                                      onPressed: () {
                                        FirebaseFirestore.instance 
                                            .collection('stories')
                                            .doc(Provider.of<Authentication>(
                                                    context,
                                                    listen: false)
                                                .getUserUid)
                                            .delete()
                                            .whenComplete(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Delete'),
                                    ))
                                  ]);
                            },
                            icon: Icon(
                              EvaIcons.moreVertical,
                              color: constantColors.whiteColor,
                            )) 
                                    
                                    // StreamBuilder<QuerySnapshot>(
                                    //   stream: FirebaseFirestore.instance
                                    //       .collection('stories')
                                    //       .doc(widget.documentSnapshot.id)
                                    //       .collection('seen') 
                                    //       .snapshots(),
                                    //   builder: (context, snapshot) {
                                    //     if (snapshot.connectionState ==
                                    //         ConnectionState.waiting) {
                                    //       return Center(
                                    //         child: CircularProgressIndicator(),
                                    //       );
                                    //     } else {
                                    //       return Text(
                                    //           snapshot.data!.docs.length
                                    //               .toString(),
                                    //           style: TextStyle(
                                    //               color:
                                    //                   constantColors.transperent ,
                                    //               fontWeight: FontWeight.bold,
                                    //               fontSize: 12));
                                    //     }
                                    //   },
                                    // )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Row(
                            children: [
                              CircularCountDownTimer(
                                  isTimerTextShown: false,
                                  width: 20,
                                  height: 20,
                                  duration: 15,
                                  fillColor: constantColors.blueColor,
                                  ringColor: constantColors.darkColor),




                            ],
                          ),
                        
                        
                        ),

                       
                      ) ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
