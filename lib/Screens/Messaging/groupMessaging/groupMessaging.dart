import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/Messaging/groupMessaging/groupMessegingHelper.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:provider/provider.dart';

class GroupMesseging extends StatefulWidget {
  GroupMesseging({required this.documentSnapshot, super.key});
  final DocumentSnapshot documentSnapshot;

  @override
  State<GroupMesseging> createState() => _GroupMessegingState();
}

class _GroupMessegingState extends State<GroupMesseging> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    Provider.of<GroupMessegingHelper>(context, listen: false)
        .checkIfJoined(context, widget.documentSnapshot.id,
            widget.documentSnapshot['useruid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessegingHelper>(context, listen: false)
              .gethasMemberJoined ==
          false) {
        Timer(
            Duration(milliseconds: 10),
            () => Provider.of<GroupMessegingHelper>(context, listen: false)
                .askToJoined(context, widget.documentSnapshot.id));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        //  centerTitle: true ,
        actions: [
          Provider.of<Authentication>(context).getUserUid ==
                  widget.documentSnapshot['useruid']
              ? IconButton(
                  onPressed: () {},
                  icon: Icon(
                    EvaIcons.moreVertical,
                    color: constantColors.whiteColor,
                  ))
              : SizedBox(),
          IconButton(
              onPressed: () {

                Provider.of<GroupMessegingHelper>(context,listen:false ).leaveTheRoom(context, widget.documentSnapshot.id); 
              },
              icon: Icon(
                EvaIcons.logOutOutline,
                color: constantColors.whiteColor,
              )),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
            )),
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.documentSnapshot['roomavatar']),
                backgroundColor: constantColors.transperent,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.documentSnapshot['roomname'],
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(widget.documentSnapshot.id)
                          .collection('members')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Text(
                            '${snapshot.data!.docs.length.toString()} Members',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
                height: MediaQuery.of(context).size.height * 0.83,
                width: MediaQuery.of(context).size.width,
                child: Provider.of<GroupMessegingHelper>(context, listen: false)
                    .showMesages(context, widget.documentSnapshot,
                        widget.documentSnapshot['useruid']),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Provider.of<GroupMessegingHelper>(context,
                          //         listen: false)
                          //     .showSticker(context, widget.documentSnapshot.id);
                              
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: constantColors.transperent,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,  
                            color: constantColors.yellowColor,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.73 ,
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Drop a Hi...',
                            hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16, 
                                fontWeight: FontWeight.w100),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: FloatingActionButton(
                            child: Icon(Icons.send_rounded),
                            backgroundColor: constantColors.greencolor1,
                            onPressed: () {
                              if (messageController.text.isNotEmpty) {
                                Provider.of<GroupMessegingHelper>(context,
                                        listen: false)
                                    .sendMessege(
                                        context,
                                        widget.documentSnapshot,
                                        messageController);
                                        messageController.clear(); 
                              }
                            }),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
