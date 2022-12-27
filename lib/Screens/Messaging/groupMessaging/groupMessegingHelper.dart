import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/Home/screenHome.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart'as timeago;


import 'package:provider/provider.dart';

class GroupMessegingHelper with ChangeNotifier {



  late String lastMessageTime;
  String get getLastMessageTime=>lastMessageTime; 
  bool hasMemberJoined = false;
  bool get gethasMemberJoined => hasMemberJoined;
  ConstantColors constantColors = ConstantColors();




leaveTheRoom(BuildContext context, String chatRoomName) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            'Leave $chatRoomName ?',
            style: TextStyle(
                color: constantColors.greenColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    )),
                MaterialButton(
                    color: constantColors.redColor,
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(chatRoomName)
                          .collection('members')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid)
                          .delete()
                          .whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: const ScreenHome(),
                                type: PageTransitionType.bottomToTop));
                      });
                    })
              ],
            )
          ],
        );
      },
    );
  }


  sendMessege(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('message') 
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'username':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserName,
      'userimage':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserImage,
    });
  }

  showMesages(BuildContext context, DocumentSnapshot documentSnapshot,
      String adminUserUid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(documentSnapshot.id)
          .collection('message')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            reverse: true,
            children:
                snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                  showLastMessageTime(documentSnapshot['time']);
              return Padding(
                padding:
                Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        documentSnapshot['useruid']?
                 const EdgeInsets.only(left: 120): 
                 const EdgeInsets.only(left: 20.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.11,
                  width: MediaQuery.of(context).size.width, 
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.1,
                              maxWidth: MediaQuery.of(context).size.width * 0.6   ,
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        documentSnapshot['useruid']?

                                          BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)) 
                                 
                                :
 BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))


                                   
                                    
                                    
                                    ,
                                color: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        documentSnapshot['useruid']
                                    ? constantColors.blueColor
                                        .withOpacity(0.8)
                                    : constantColors.blueGreyColor), 
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150 ,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                            documentSnapshot['username'],
                                            style: TextStyle(
                                                color:
                                                    constantColors.greenColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      //  Provider.of<Authentication>(context,
                                      //                 listen: false)
                                      //             .getUserUid != 
                                      //         adminUserUid
                                      //     ? Padding(
                                      //         padding: const EdgeInsets.only(
                                      //             left: 8.0),
                                      //         child: Icon(
                                      //           FontAwesomeIcons.chessKing,
                                      //           size: 12,
                                      //           color:
                                      //               constantColors.yellowColor,
                                      //         ),
                                      //       )
                                      //     : const SizedBox()
                                    ],
                                  ),
                                ),
 
                                //  Padding(
                                //   padding: const EdgeInsets.only(left: 8.0),
                                //   child: Text(documentSnapshot['message'],
                                //       style: TextStyle(
                                //           color: constantColors.whiteColor,
                                //           fontSize: 14,
                                //           fontWeight: FontWeight.normal)),
                                // )
                              //  documentSnapshot['message']!=null?
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(documentSnapshot['message'],
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal)),
                                ),
                                // :   
                                // Container(
                                //   height: 100,
                                //   width: 100,
                                //   child: Image.network(documentSnapshot['sticker']), 
                                // )

                                Align(alignment:Alignment.bottomRight ,
                                  child: Container(
                                    width: 80,
                                    child: Text(getLastMessageTime,style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontSize: 6,
                                            fontWeight: FontWeight.normal)),),
                                ),
                                 



                              ], 
                            ),
                          )
                        ],
                      ),
                      // Positioned(
                      //   // left:5  ,
                      //   child: Provider.of<Authentication>(context,listen: false).getUserUid!=
                      //   documentSnapshot['useruid']?
                      //   SizedBox():
                      //   CircleAvatar(
                      //     backgroundColor: constantColors.darkColor,
                      //     backgroundImage: NetworkImage(documentSnapshot['userimage']),
                      //   ))
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Future checkIfJoined(BuildContext context, String chatRoomName,
      String chatRoomAdminUid) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      hasMemberJoined = false;
      print('Initial state ===>>> $hasMemberJoined');
      if (value['joined'] != null) {
        hasMemberJoined = value['joined'];
        print('final State===>>>$hasMemberJoined');
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserUid ==
          chatRoomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoined(BuildContext context, String roomName) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text('Join $roomName',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  },
                  child: Text('No',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 15,
                          fontWeight: FontWeight.normal)),
                ),
                MaterialButton(
                    color: constantColors.redColor,
                    child: Text('Yes',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(roomName)
                          .collection('members')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid)
                          .set({
                        'joined': true,
                        'username': Provider.of<FirebaseOpretions>(context,
                                listen: false)
                            .initUserName,
                        'userimage': Provider.of<FirebaseOpretions>(context,
                                listen: false)
                            .initUserImage,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                        'time': Timestamp.now()
                      }).whenComplete(() {
                        Navigator.pop(context);
                      });
                    })
              ],
            )
          ],
        );
      },
    );
  }

  showSticker(BuildContext context, String chatroomid) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 105),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.48,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('stickers')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1),
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                   sendStikers(context,
                                      documentSnapshot['image'], chatroomid);
                                },
                                child: Container(
                                  color: constantColors.greyColor1,
                                  height: 40,
                                  width: 40,
                                  child:
                                      Image.network(documentSnapshot['image']),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  sendStikers(
      BuildContext context, String stickerImageUrl, String chatRoomId) async {
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('message')
        .add({
      'sticker': stickerImageUrl,
      'username':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserName,
      'userimage':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserImage,
      'time': Timestamp.now()
    });
  }


  showLastMessageTime(dynamic timeData){
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();

    lastMessageTime=timeago.format(dateTime);
    print(lastMessageTime);
    notifyListeners(); 


  }
}
